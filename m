From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: fix array termination by appending NULL to attr
 array
Date: Wed, 10 May 2017 13:25:54 -0400
Message-ID: <e6273c0a-1dd5-ff53-87ad-e1c4181a01db@intel.com>
References: <1494431652-67941-1-git-send-email-robers97@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494431652-67941-1-git-send-email-robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Steven L. Roberts" <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/10/2017 11:54 AM, Steven L. Roberts wrote:
> From: "Steven L. Roberts" <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> This fixes a kernel panic when loading the hfi driver as a dynamic module.
>
> Signed-off-by: Steven L Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
