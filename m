From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [UPDATED PATCH] [0/3] Support libibnetdiscover
	caching
Date: Fri, 15 Jan 2010 10:23:02 -0800
Message-ID: <1263579782.15172.164.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

[This is a repost w/ updates and updated patches from my posts Dec 09, I
assume the patches fell off your list :-)]

I've added two new functions into libibnetdisc, ibnd_cache_fabric() and
ibnd_load_fabric().  As the names suggest, these functions allow the
user to store the ibnd_fabric_t fabric to disk and read it back later
on.  The patches add the functions and the base functionality to
ibnetdiscover, iblinkinfo, and ibqueryerrors.  Some of the current and
future benefits of this are:

- Give users the option to have IB diag tools load the cached version of
the fabric instead of scanning the IB fabric.  Not only does this make
the tools faster, it allows users to debug, analyze, play, etc.
with a fabric state that existed in the past.  Or a fabric that they
don't even have access to (e.g. send the current fabric to support
staff).

- Support new debug/analysis features into IB diag tools.  One example
is a "diff" type of debug/analysis feature that allows users to compare
how the current fabric state is different than a previous time.  Another
idea is a "filter" type of option.  Some users who have a number of
unpopulated switch ports have said they'd like to limit the output of
the diag tools.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
