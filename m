From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: GIT tree for OFED 1.5.x latest source code
Date: Sun, 26 Dec 2010 09:43:38 +0200
Message-ID: <4D16F22A.2080803@dev.mellanox.co.il>
References: <980813.87185.qm@web30101.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <980813.87185.qm-fAmYO6fE+wWvuULXzWHTWIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/24/2010 10:35 AM, Parav Pandit wrote:
> Hi,
>
> Can anyone please confirm,
> which is the latest OFED 1.5.x tree against which enhancements/fixes/new functionality/modules patches can be applied after reviews?
>
> Is it the same tree that will be use for merging with kernel.org?
>
> Can you please confirm, is it the below one?
> http://git.openfabrics.org/git?p=ofed_1_5/linux-2.6.git;a=summary
>
> Regards,
> Parav Pandit
>
>

Hi Parav,
The latest OFED's git tree is git://git.openfabrics.org/ofed_1_5/linux-2.6.git branch: ofed_kernel_1_5
It is not the tree for merging with kernel.org.

For merging with kernel.org use Roland's tree:
git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
Branch: for-next

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
