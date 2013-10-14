From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/9] IB/core: batch of fix against create/destroy_flow
 uverbs for v3.12
Date: Mon, 14 Oct 2013 18:36:51 +0300
Message-ID: <525C0F93.3000005@mellanox.com>
References: <cover.1381510045.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/10/2013 20:18, Yann Droneaud wrote:
> As requested by Or Gerlitz, I've rebased my previous fixes [1]
> against Matan Barak patch [2]. I've added two patches to fix issues
> left or introduced by this patch.
> Regarding the previous patchset [1], I've kept the public data
> structure improving and renaming patches, but, in order to minimize
> the overall changes, I've removed the changes which were modifying
> the functions and variables names in the code.
> I've removed "code beautifying" and left "hardening" / cleanup changes
> for a latter release.
>
> On top of this, I've added the two acknowledged and important patches
> from my extended command infrastructure [3]. I've made cleanups in the
> changelog regarding the 'email' citations.
Hi Yann, Matan provided some feedback, I think he has little more which 
he will send tomorrow. Please make sure to use version-ing for the patch 
series, e.g if I got it right, this post was V2 and the next is V3 -- so 
you can just --subject-prefix="PATCH V3" for git format-patch,  also 
leave the listing of the change history on the cover letter e.g

V2 --> V3 changes:

xxx - what you will change in V3

V1 --> V2 changes:

yyy (what's written above)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
