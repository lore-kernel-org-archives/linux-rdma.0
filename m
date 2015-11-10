From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH ib-next 2/3] IB/core: IB/core: Allow legacy verbs through
 extended interfaces
Date: Tue, 10 Nov 2015 17:40:26 +0200
Message-ID: <20151110154026.GC114170@x-vnc01.mtx.labs.mlnx>
References: <1446745208-17733-1-git-send-email-eli@mellanox.com>
 <1446745208-17733-3-git-send-email-eli@mellanox.com>
 <CAAKD3BDq_o+J3yM1qAKg_x35Dps5Ne_ffaD_Mz55a272pwQcJg@mail.gmail.com>
 <564041C4.1090303@mellanox.com>
 <20151109223531.GB1305@obsidianresearch.com>
 <20151109230531.GF20103@x-vnc01.mtx.labs.mlnx>
 <20151109231542.GA20707@obsidianresearch.com>
 <20151109232431.GA114170@x-vnc01.mtx.labs.mlnx>
 <20151109233059.GA21475@obsidianresearch.com>
 <20151110152310.GB114170@x-vnc01.mtx.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110152310.GB114170-lgQlq6cFzJSjLWYaRI30zHI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 05:23:10PM +0200, Eli Cohen wrote:
> > 
> > Call it ENOTSUP then:
> > 
> >        ENOTSUP         Operation not supported (POSIX.1)
> > 
> > Same value on Linux.
> > 
> 
> Yes, that's better. I will resend.


Well it seems like ENOTSUP is defined only here:

./arch/parisc/include/uapi/asm/errno.h:115:#define ENOTSUP 252     /* Function not implemented (POSIX.4 / HPUX) */

Which obviously I cannot use. Jason, do you have another idea?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
