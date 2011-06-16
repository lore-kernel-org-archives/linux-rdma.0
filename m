From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: saquery; reuse
 dump_one_mcmember_record function
Date: Thu, 16 Jun 2011 15:48:33 -0700
Message-ID: <20110616154833.8005a2c9.weiny2@llnl.gov>
References: <20110616111024.fde795bc.weiny2@llnl.gov>
	<4DFA6D60.9070609@dev.mellanox.co.il>
	<20110616144636.4d2483fb.weiny2@llnl.gov>
	<20110616215946.GA7112@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110616215946.GA7112-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 16 Jun 2011 14:59:46 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Thu, Jun 16, 2011 at 02:46:36PM -0700, Ira Weiny wrote:
> 
> > "need"; I guess not.  But I thought it was odd that the information was different for the 2 query methods.  There is nothing in the documentation or help output which indicates the output would be different.
> > 
> > That said I do see what you mean regarding the amount of data
> > returned.  I figured most users were probably grepping this output
> > anyway, as on a large fabric both methods return a sizable amount of
> > data.
> 
> One is supposed to return de-duplicated information about the groups
> that exist, the other was supposed to show group member information.

[caveat]
I am not trying to beat a dead horse...
[/caveat]

I guess it depends on what you define as "member info" and what that implies to the user. ("de-duplicated" or not.)

       -m     get  multicast  member info.  If a group is specified, limit the output to the group specified
              and print one line containing only the GUID and node  description  for  each  entry.  Example:
              saquery -m 0xc000

To me this implied "de-duplication" only occurred with the mlid specified.  But..  I'm happy.

Ira

> 
> Jason


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
