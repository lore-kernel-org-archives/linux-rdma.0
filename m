From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC v2 00/10] Introduce Signature feature
Date: Thu, 31 Oct 2013 15:20:48 +0200
Message-ID: <52725930.7030702@mellanox.com>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com> <5272535D.4090805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5272535D.4090805-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Nicholas Bellinger <nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/31/2013 2:55 PM, Jack Wang wrote:
> Hi Sagi,
>
> I wander what's the performance overhead with this DIF support?
> And is there a roadmap for support SRP/ISER and target side for DIF?
>
> Regards,
> Jack

Well, all DIF operations are fully offloaded by the HCA so we don't expect
any performance degradation other than the obvious 8-bytes integrity 
overhead.
We have yet to take benchmarks on this and we definitely plan to do so.

Regarding our roadmap, we plan to support iSER target (LIO) and 
initiator first.
Some prior support for DIF needs to be added in target core level,
then transport implementation is pretty straight-forward (iSER/SRP).

So I aim for iSER DIF support (target+initiator) to make it into v3.14.

Hope this helps,

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
