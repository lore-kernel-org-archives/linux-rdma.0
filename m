From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: 0-day build issues
Date: Thu, 24 Sep 2015 13:53:31 -0400 (EDT)
Message-ID: <42EC4987-428D-4988-BDDD-6B80915AA44C@redhat.com>
References: <32E1700B9017364D9B60AED9960492BC257D3D76@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC257D3D76-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kbuild-all-JC7UmRfGjtg@public.gmane.org" <kbuild-all-JC7UmRfGjtg@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jim Davis <jim.epost-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

What is being done in the parent directory has a bug, you're right that far, but this is the wrong fix. If you check the 0day failures, it isn't because the InfiniBand core isn't enabled, it's because the current menuconfig setup allows the IB core to be a module and the staging drivers to be compiled into the kernel. That obviously is an invalid condition and it applies to all of the drivers in staging right now. The correct fix is to resolve that issue. 

Sent from my iPhone

> On Sep 24, 2015, at 1:47 PM, Marciniszyn, Mike <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> Doug,
> 
> I think we need to apply http://www.spinics.net/lists/linux-rdma/msg27914.html and https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg26989.html.
> 
> We just got http://marc.info/?l=linux-rdma&m=144311398317945&w=2.   Whatever we tried to do in the parent directory isn't working, and since ipath is to be removed and hfi1 is hopefully moving into its proper location, I think it is prudent to just apply the above patches.
> 
> Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
