From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [OPENSM] cast to remove warnings about signed vs. unsigned comparisons
Date: Thu, 1 Oct 2009 10:10:13 -0700
Message-ID: <5700CAE1904A41378DAE71D5F81B9C55@amr.corp.intel.com>
References: <839303D0FDC14F77AE516FDC9CF8B6A7@amr.corp.intel.com> <20091001155613.GN17846@me> <3F6F638B8D880340AB536D29CD4C1E1912C86E862B@orsmsx501.amr.corp.intel.com> <20091001162715.GC22310@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091001162715.GC22310-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>I've always felt the warning on implicit cast from larger to smaller
>type to be somewhat useless - that is an unavoidable operation when
>working with networking. Adding casts does nothing to actually improve
>the code, and trying to change to smaller types results in worse code
>gen and no improvement in function.

An explicit cast lets someone reading the code know that the original programmer
was aware that data could be loss, or that data loss wouldn't occur because of
the range of the data.  IMO, adding explicit casts to the code is better than
having an equally number of implicit casts.

>Maybe OFW would be better off just turning that warning off? :)

I've tried.  If there's a way to do this, I haven't found it.  The /W<whatever
number this is> option hasn't worked for me.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
