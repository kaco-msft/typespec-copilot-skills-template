import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@microsoft/typespec-copilot-skills";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypespecCopilotSkills;

enum orchestratorState {
  reasoning,
  responding
}

alias sunoSkill = {
  nameForHuman: "Suno";
  descriptionForModel: "Suno is a tool that can generate songs based on a description. The user provides a description of the song they want to create, and Suno generates the song lyrics. Suno is a fun and creative way to create songs for any occasion.";
  contactEmail: "ionutro@microsoft.com";
  //logoUrl: "https://th.bing.com/th?id=OSK.935650835684F7E18AC3F31034DE6DF3";
  privacyPolicyUrl: "https://app.suno.ai/privacy";
  legalInfoUrl: "https://app.suno.ai/legal";
};

/**
 * Suno is a tool that can generate songs based on a description. The user provides a description of the song they want to create, and Suno generates the song lyrics. Suno is a fun and creative way to create songs for any occasion.
 */
@service({
  title: "Suno"
})
@route("/createSong")
@skill(sunoSkill)
namespace Suno {
  /** Create a song given the user preferences */
  @get op createSong(
    /** The requested song description, eg. `a country song about Thanksgiving` */
    @query topic: string,
    /** The requested song genre, eg. `Jazz` */
    @query genre?: string
  ): string;
    @@state(createSong, orchestratorState.reasoning, #{
    description: " creates a song about a given topic. This tool is only invoked if the request parameter is a safe and innocuous topic.",
    instructions: """
      Is the user requesting to create a song which would warrant the "Parental Advisory Explicit Content" label (e.g. topics about sex, politics, violence, self-harm, hate speech, coercion, etc.)? If so, I **must** invoke `withdraw()` and end the conversation.
      Is the user requesting to create a haiku, poem, lyric, tune, melody, jingle, verse, sonnet or something other than a song?, If so, I **must not** invoke `createSong(**params)`.
      Is the user requesting to create a song on a safe and innocuous topic? If so, invoke `createSong(**params)`.
      If () is invoked already in this turn, I **will** not invoke the same tool again
      Here are the parameters: 
        * : , in the user's language
        * : ,
    """
  });

  @@state(createSong, orchestratorState.responding, #{
    description: " creates a song about a given topic. This tool is only invoked if the request parameter is a safe and innocuous topic.",
    instructions: """
        The response to the user is generated asynchronously therefore I **SHOULD NOT** generate my own song or provide links or lyrics based on this tool's output. I can just let the user know their song will be available shortly and **stop responding** for that turn.
        I **should not** respond with either sample or full form of lyrics to the song because the song created by `createSong(**params)` is shown to the user directly along with the lyrics.
        If () was not invoked because the service was overloaded or the user reached their invocation limit, I **must** tell the user they can visit the `https://app.suno.ai` website to create more songs and display the link using Markdown syntax.
        I **shall** tell the user they can visit the `https://app.suno.ai` website to create more songs and display the link using Markdown syntax.
      """
  });
}