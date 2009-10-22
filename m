From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] [RFC] rdma/cm: support option to allow manually	setting IB path
Date: Thu, 22 Oct 2009 11:28:11 -0700
Message-ID: <67280F81CB6F417DA6EEE22448ED5500@amr.corp.intel.com>
References: <20091020181458.GD14520@obsidianresearch.com> <46770152ACA04B6C8AA9497C45AC8FD0@amr.corp.intel.com> <20091020191404.GH14520@obsidianresearch.com> <9DFD8E65325F4EE990749EEBE4BC33CA@amr.corp.intel.com> <20091022004245.GV14520@obsidianresearch.com> <AE35305D45DB49F591A45DADD822209A@amr.corp.intel.com> <20091022013542.GX14520@obsidianresearch.com> <B7E97540810E4A2785FF1FC8CB96F453@amr.corp.intel.com> <20091022165414.GH26003@obsidianresearch.com> <1438C87E89284364A56E08A40DFE199E@amr.corp.intel.com> <20091022181101.GY14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091022181101.GY14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>> if (number of paths > 1)
>> 	return -ENOSYS;
>
>This is really no different than what you had at first.

The main difference is returning ENOSYS to indicate that only one path is
acceptable.

>My idea was to have the kernel search the array for the entries it
>needs/supports. First one found wins. This provides future
>API compatability.
>
>Some future userspace, to support some future kernel APM, would pass in 2
>entries:
> IB_PATH_GMP | IB_PATH_PRIMARY | IB_PATH_OUTBOUND | IB_PATH_INBOUND
> IB_PATH_GMP | IB_PATH_ALTERNATE | IB_PATH_OUTBOUND | IB_PATH_INBOUND
>
>This shouldn't break old kernels.

I don't like the idea of the kernel silently ignoring the alternate path.
Returning an error seems like a better idea.

>Again, some even future kernel would support 6 entries, future user
>space would send this:
> IB_PATH_PRIMARY | IB_PATH_INBOUND
> IB_PATH_PRIMARY | IB_PATH_OUTBOUND
> IB_PATH_GMP | IB_PATH_PRIMARY | IB_PATH_OUTBOUND | IB_PATH_INBOUND
> IB_PATH_ALTERNATE | IB_PATH_INBOUND
> IB_PATH_ALTERNATE | IB_PATH_OUTBOUND
> IB_PATH_GMP | IB_PATH_ALTERNATE | IB_PATH_OUTBOUND | IB_PATH_INBOUND
>
>This shouldn't break old kernels either.

To me, this sets contradictory paths.  The pairings <PRI | IN>, <PRI | OUT>,
<ALT | IN>, <ALT | OUT> should appear exactly once in a set of paths.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
