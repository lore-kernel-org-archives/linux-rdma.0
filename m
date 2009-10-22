From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_vendor_ibumad: Use OSM_UMAD_MAX_AGENTS
 rather than UMAD_CA_MAX_AGENTS
Date: Thu, 22 Oct 2009 15:28:46 +0200
Message-ID: <20091022132846.GI20210@me>
References: <f0e08f230910220549g1035441dj3b89e543c44efd3a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910220549g1035441dj3b89e543c44efd3a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08:49 Thu 22 Oct     , Hal Rosenstock wrote:
> 
> I thought the subject was sufficient and seems to be included in the
> commits. Is that true ?

Subject is just *one* line patch summary and not patch description (as
you trying to use it). 

> What are you looking for here that is not
> being done ?

Specifically the patch motivation was unclear to me. And this is due to
violation of patch submitting recommendations: Look at

/usr/src/linux/Documentation/SubmittingPatches

, specifically #2 and #15 in Section 1.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
