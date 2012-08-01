From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/8] opensm: Improved mkey support
Date: Wed, 1 Aug 2012 23:19:20 +0300
Message-ID: <20120801201920.GI1661@calypso>
References: <1340672058.5218.97.camel@auk75.llnl.gov>
 <1343832537.26423.8.camel@auk75.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1343832537.26423.8.camel-mxTxeWJot8FliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

hi Jim

On 07:48 Wed 01 Aug     , Jim Foraker wrote:
> v2 is about to be posted.  It is now a 9-patch set.  Changes from v1:
> 
> . Subnet initialization behavior changed to log errors on SubnGet
> timeouts, but not flag the init as failed, so that we don't heavy sweep
> more than necessary
> . sldd.sh modified to sync multiple files, and neighbors/guid2mkey
> caches added to its default list
> . Rebased against current HEAD
> . Several whitespace/code format/git log cleanup fixes
> 
>      There will be a man page patch coming shortly, but I want to get
> these out the door for review now.
> 
>      Jim
> 

Applied the series, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
