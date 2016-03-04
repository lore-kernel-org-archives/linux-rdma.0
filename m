From: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 6/8] IB/core: generic RDMA READ/WRITE API
Date: Fri, 4 Mar 2016 18:13:38 +0100
Message-ID: <20160304171338.GA29377@lst.de>
References: <1457028192-24965-1-git-send-email-hch@lst.de> <1457028192-24965-7-git-send-email-hch@lst.de> <019e01d17587$a7b11490$f7133db0$@opengridcomputing.com> <01a401d1758e$0a227050$1e6750f0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <01a401d1758e$0a227050$1e6750f0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 03, 2016 at 02:48:28PM -0600, Steve Wise wrote:
> With the above change undone, your rdma-rw-api branch tests out ok with iser/iwarp.
> 
> Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

I've updated the git tree with the proper squashing of the list_del
fix and your Tested-by: tags.  I'll wait for more reviews to trickle
in before resending.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
