From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] IPoIB TX NAPI
Date: Wed, 25 Oct 2017 13:24:48 -0400
Message-ID: <1508952288.3325.34.camel@redhat.com>
References: <20171016054901.32479-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016054901.32479-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-10-16 at 08:48 +0300, Leon Romanovsky wrote:
> It is very common in modern network devices to use NAPI in RX and TX,
> in the UD/TX flows IPoIB uses a polling mechanism (not as it does in
> the CM mode).
> 
> Except of the motivation to use the same mechanism for IPoIB as for
> netdevices, there are number of issues in current polling mechanism:
>  * SKBs that are kept longer than they should be and there are
> applications
>    that warn about that (some firewalls for example).
>  * Statistics that are not updated to the real value. It blocks
> support
>    for time synchronization protocols over the IPoIB protocol, like
> PTP
>    and so on.
>  * The TX in CM mode already uses NAPI, there is no reason to keep
> two
>    different ways for TX one for UD and one for the CM.
> 
> The patches are available in the git repository at:
>   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> tags/rdma-next-2017-10-16-2
> 
>         Thanks

Thanks, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
