From: Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: GIT tree for OFED 1.5.x latest source code
Date: Wed, 5 Jan 2011 04:02:10 -0800 (PST)
Message-ID: <217139.95997.qm@web30104.mail.mud.yahoo.com>
References: <4D16F22A.2080803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D16F22A.2080803-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



--- On Sun, 12/26/10, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Subject: Re: GIT tree for OFED 1.5.x latest source code
> To: "Parav Pandit" <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Date: Sunday, December 26, 2010, 1:13 PM
> On 12/24/2010 10:35 AM, Parav Pandit
> wrote:
> > Hi,
> >
> > Can anyone please confirm,
> > which is the latest OFED 1.5.x tree against which
> enhancements/fixes/new functionality/modules patches can be
> applied after reviews?
> >
> > Is it the same tree that will be use for merging with
> kernel.org?
> >
> > Can you please confirm, is it the below one?
> > http://git.openfabrics.org/git?p=ofed_1_5/linux-2.6.git;a=summary
> >
> > Regards,
> > Parav Pandit
> >
> >
> 
> Hi Parav,
> The latest OFED's git tree is
> git://git.openfabrics.org/ofed_1_5/linux-2.6.git branch:
> ofed_kernel_1_5
> It is not the tree for merging with kernel.org.
> 
[PP] I am not able to clone this tree and branch. It says connection timeout. I able to clone the Roland's tree.

git clone -b ofed_kernel_1_5 git://git.openfabrics.org/ofed_1_5/linux-2.6.git
Cloning into linux-2.6...
git.openfabrics.org[0: 69.55.231.68]: errno=Connection timed out
fatal: unable to connect a socket (Connection timed out)




> For merging with kernel.org use Roland's tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
> Branch: for-next
> 
> Regards,
> Vladimir
> 


      
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
