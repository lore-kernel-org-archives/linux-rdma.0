From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH] Set HopLimit based on off subnet Re: SRP issues
 with OpenSM 3.3.3
Date: Sun, 20 Dec 2009 21:57:10 +0200
Message-ID: <20091220195710.GA18524@me>
References: <20091214164334.064102f0.weiny2@llnl.gov>
 <20091215170317.GV5262@me>
 <20091215171532.GA8288@obsidianresearch.com>
 <20091215091819.c217cf36.weiny2@llnl.gov>
 <f0e08f230912150959j536667bbg51b8381724681880@mail.gmail.com>
 <20091215185511.3ae458cc.weiny2@llnl.gov>
 <f0e08f230912160529h64424ba7id5c57dffb770380c@mail.gmail.com>
 <20091217181800.a1ee6b9b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091217181800.a1ee6b9b.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 18:18 Thu 17 Dec     , Ira Weiny wrote:
> 
> It might be faster but it would mean a bigger change.  It looks like having
> the dgid or p_pr structures in some internal opensm structure to carry that
> information along would be best but that is a lot of work.

Actually now dgid parameter is never used when intra-subnet PR is
requested - maybe those parameters (dgid, is_off_subnet, etc.) could be
merged into some context struct which is initialized once and passed down
to the functions.

Likely some general cleanup of osm_sa_path_record.c is needed to see a
most obvious coding solution.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
