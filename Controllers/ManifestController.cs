using Microsoft.AspNetCore.Mvc;
using Octokit;

namespace ScoopBucketApi.Controllers;

[ApiController]
[Route("api/{id}")]
public sealed class ManifestController : ControllerBase
{
    private readonly IGitHubClient _gitHubClient;

    public ManifestController(IGitHubClient gitHubClient)
    {
        _gitHubClient = gitHubClient;
    }

    [HttpGet]
    public async Task<App> Get(string id)
    {
        
        
        return new App(id, id, id, id);
        // return new App("", "", "", "");
    }
}

public record App(string Name, string Url, string Version, string Hash);
