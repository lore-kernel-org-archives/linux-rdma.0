From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [OPENSM] cast to remove warnings about signed vs. unsigned	comparisons
Date: Thu, 1 Oct 2009 11:43:22 -0700
Message-ID: <7C799D30BD9A4AFBB2F99080871974BD@amr.corp.intel.com>
References: <839303D0FDC14F77AE516FDC9CF8B6A7@amr.corp.intel.com> <20091001155613.GN17846@me> <3F6F638B8D880340AB536D29CD4C1E1912C86E862B@orsmsx501.amr.corp.intel.com> <20091001162715.GC22310@obsidianresearch.com> <5700CAE1904A41378DAE71D5F81B9C55@amr.corp.intel.com> <20091001182734.GI19540@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091001182734.GI19540-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>The biggest problem is that the cast is only correct if the types
>never change. If someone changes the type then every instance of every
>cast must be tracked down and fixed too. This is a huge maintenance
>burden that implict casting avoids.

You could definitely argue that by changing the type of a variable, you should
validate its usage anywhere it's used.

Trying to assign a variable of one type to another is a valid warning that
should be looked at.  Disabling the warning is not the best solution.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
