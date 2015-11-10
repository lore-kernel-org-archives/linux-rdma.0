From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH ib-next 2/3] IB/core: IB/core: Allow legacy verbs through
 extended interfaces
Date: Tue, 10 Nov 2015 13:10:11 -0700
Message-ID: <20151110201011.GA20985@obsidianresearch.com>
References: <564041C4.1090303@mellanox.com>
 <20151109223531.GB1305@obsidianresearch.com>
 <20151109230531.GF20103@x-vnc01.mtx.labs.mlnx>
 <20151109231542.GA20707@obsidianresearch.com>
 <20151109232431.GA114170@x-vnc01.mtx.labs.mlnx>
 <20151109233059.GA21475@obsidianresearch.com>
 <20151110152310.GB114170@x-vnc01.mtx.labs.mlnx>
 <20151110154026.GC114170@x-vnc01.mtx.labs.mlnx>
 <56424437.9090908@sandisk.com>
 <20151110200226.GB21849@x-vnc01.mtx.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110200226.GB21849-lgQlq6cFzJSjLWYaRI30zHI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 10:02:26PM +0200, Eli Cohen wrote:
> On Tue, Nov 10, 2015 at 11:23:35AM -0800, Bart Van Assche wrote:
> > 
> > How about using ENOTSUPP ?
> > 
> > $ PAGER= git grep 'define ENOTSUPP' include
> > include/linux/errno.h:#define ENOTSUPP 524 /* Operation is not supported */
> > 
> 
> Appearently this looks a better option but the following appears as a
> icomment above this group: /* Defined for the NFSv3 protocol */
> 
> I don't mind using this if we can all agree that this is the best
> choise.

We cannot use ENOTSUPP, it is not supported by userspace, there was a
list discussion about that a while back.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
