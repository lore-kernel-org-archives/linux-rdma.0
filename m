From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH ib-next 2/3] IB/core: IB/core: Allow legacy verbs through
 extended interfaces
Date: Tue, 10 Nov 2015 01:24:31 +0200
Message-ID: <20151109232431.GA114170@x-vnc01.mtx.labs.mlnx>
References: <1446745208-17733-1-git-send-email-eli@mellanox.com>
 <1446745208-17733-3-git-send-email-eli@mellanox.com>
 <CAAKD3BDq_o+J3yM1qAKg_x35Dps5Ne_ffaD_Mz55a272pwQcJg@mail.gmail.com>
 <564041C4.1090303@mellanox.com>
 <20151109223531.GB1305@obsidianresearch.com>
 <20151109230531.GF20103@x-vnc01.mtx.labs.mlnx>
 <20151109231542.GA20707@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151109231542.GA20707-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 09, 2015 at 04:15:42PM -0700, Jason Gunthorpe wrote:
> 
> Since the change is to make the kernel do the above fall back
> internally, this specific example doesn't make alot of sense to worry
> about. Ie the extended verb won't fail anymore, and if it does the
> legacy one won't work anyhow.
> 

Makes sense.

> But if there is something out there that does care about ENOSYS we
> should try to keep it, but don't convert ENOSYS to EINVAL.
> 
> Also, when the driver tests the ex flags for support it should be
> returning EOPNOTSUPP or such not EINVAL.. Return codes for the ex
> stuff could stand a good sanity audit.
> 

#define EOPNOTSUPP      95      /* Operation not supported on
transport endpoint */

This does not seem like an ideal choise either. I think ENOSYS in this
case is a better choise.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
