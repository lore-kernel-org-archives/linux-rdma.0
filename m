From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V1] RDMA/cma: Fix multicast joins of the IPoIB
 port space to be consistent
Date: Tue, 18 Sep 2012 23:16:08 +0300
Message-ID: <CAJZOPZK+ArsY_iRt0vSSW2of3z=_gFy-o03-TNyT+pLWUrfyEQ@mail.gmail.com>
References: <1346317795-12622-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346317795-12622-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 30, 2012 at 12:09 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> CMA multicast joins done under the ipoib port state must be carried
> out using the same component mask used by ipoib. Otherwise, its possible
> for the CMA to create a group to which a join made by ipoib will fail,
> or vise-versa. So far this wasn't the case, since some of the component
> mask fields set by ipoib weren't set by the CMA, fix that.

> ---
>
> changes from V0:
>  - removed setting of the multicast record fields, since they are kept
>    in the ib sa client data base, only deal with the component mask fields.

Hi Roland,

I see now that you've picked the batch of small patches I sent for
3.7,  so we're starting to merge code, lovely update... just wanted to
make sure you put this one there too, its simple and acked by Sean.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
