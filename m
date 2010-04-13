From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [0/3] support --diff and --diffcheck in
 ibnetdiscover
Date: Tue, 13 Apr 2010 16:08:03 +0300
Message-ID: <20100413130803.GG10830@me>
References: <1270659929.26381.38.camel@crazyclimber.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1270659929.26381.38.camel-RLKWKRZIcZkVVsCFsIUZTRy+HRzXvqW9@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On 10:05 Wed 07 Apr     , Al Chu wrote:
> 
> Others on the list may wonder how this is different than just using the
> normal 'diff' tool.  The differences I can think of are:
> 
> 1) This checks differences in the network, not text.  This is
> particularly important when lids, lmc, etc. are changed.  Otherwise
> there are many differences in a normal diff output that aren't
> necessary.
> 
> 2) This provides the appropriate "context" in the diff output, showing
> the appropriate system ids to allow a system administrator to identify
> ports on what switch have changed.  Under normal diff output, you may
> not get that appropriate context of information.  The system
> administrator can of course use options like --context in diff, but the
> goal is to make the diff output clear and concise, not outputting
> unnecessary junk.
> 
> 3) As parallelization has been added into ibnetdisocver/libibnetdiscover
> this becomes more critical as output in ibnetdiscover/libibnetdiscover
> can be re-ordered.  So a normal diff suddenly is non-functional.

I'm getting your arguments. And this remind me the question which was
already raised some time ago.

Would it be better to keep cache in a regular human readable
ibnetdiscover output format, so '--diff' will be usable not just against
cache, but also against a regular ibnetdiscover output files?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
