From: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/IPoIB: ibX: failed to create mcg debug file
Date: Wed, 29 Mar 2017 13:20:20 +0300
Message-ID: <20170329102019.GA19012@srabinov-linux.uk.oracle.com>
References: <1490599139-12665-1-git-send-email-shamir.rabinovitch@oracle.com>
 <20170327195500.GH20443@mtr-leonro.local>
 <20170327201714.GB29831@srabinov-linux.uk.oracle.com>
 <20170328091940.GA14058@srabinov-linux.uk.oracle.com>
 <20170328170506.GI20443@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170328170506.GI20443-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 28, 2017 at 08:05:06PM +0300, Leon Romanovsky wrote:
> 
> Thank you for checking it.
> 
> There is one more thing which I noticed, you should check the return
> values of debugfs_remove and destroy debugfs in case of failures.
> 

Hi Leon, 

'debugfs_remove' prototype is "static inline void
debugfs_remove(struct dentry *dentry)". 
If you typed the wrong function please let me know.

BR, Shamir 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
