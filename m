From: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/IPoIB: ibX: failed to create mcg debug file
Date: Tue, 28 Mar 2017 20:52:55 +0300
Message-ID: <20170328175254.GA29389@srabinov-linux.uk.oracle.com>
References: <1490599139-12665-1-git-send-email-shamir.rabinovitch@oracle.com>
 <4058624b-a947-9635-76ca-482fd6a6bd95@mellanox.com>
 <20170327201156.GA29831@srabinov-linux.uk.oracle.com>
 <a141c94a-63b7-491c-ce42-9b8cb08aeb93@mellanox.com>
 <20170328160251.GA26781@srabinov-linux.uk.oracle.com>
 <e3a49c96-b248-7491-301d-faa47109aa41@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e3a49c96-b248-7491-301d-faa47109aa41-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 28, 2017 at 07:49:08PM +0300, Mark Bloch wrote:
> I agree that we call ipoib_delete_debug_files() from ipoib_netdev_event()
> the right number of times, but we also call it in ipoib_dev_cleanup()
> which means we call it too many times. Your V3 didn't remove that call.
>  
> 
> Mark.

Thanks for the review Mark. Yes you are correct. Patch need fix.

BR, Shamir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
