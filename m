From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH ib-next 2/3] IB/core: IB/core: Allow legacy verbs through
 extended interfaces
Date: Tue, 10 Nov 2015 17:23:10 +0200
Message-ID: <20151110152310.GB114170@x-vnc01.mtx.labs.mlnx>
References: <1446745208-17733-1-git-send-email-eli@mellanox.com>
 <1446745208-17733-3-git-send-email-eli@mellanox.com>
 <CAAKD3BDq_o+J3yM1qAKg_x35Dps5Ne_ffaD_Mz55a272pwQcJg@mail.gmail.com>
 <564041C4.1090303@mellanox.com>
 <20151109223531.GB1305@obsidianresearch.com>
 <20151109230531.GF20103@x-vnc01.mtx.labs.mlnx>
 <20151109231542.GA20707@obsidianresearch.com>
 <20151109232431.GA114170@x-vnc01.mtx.labs.mlnx>
 <20151109233059.GA21475@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151109233059.GA21475-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 09, 2015 at 04:30:59PM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 10, 2015 at 01:24:31AM +0200, Eli Cohen wrote:
> > > Also, when the driver tests the ex flags for support it should be
> > > returning EOPNOTSUPP or such not EINVAL.. Return codes for the ex
> > > stuff could stand a good sanity audit.
> > > 
> > 
> > #define EOPNOTSUPP      95      /* Operation not supported on
> > transport endpoint */
> > 
> > This does not seem like an ideal choise either. I think ENOSYS in this
> > case is a better choise.
> 
> Call it ENOTSUP then:
> 
>        ENOTSUP         Operation not supported (POSIX.1)
> 
> Same value on Linux.
> 

Yes, that's better. I will resend.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
