From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/vendstat: Fixed general info query
Date: Mon, 2 May 2011 11:16:33 -0700
Message-ID: <20110502111633.838df84e.weiny2@llnl.gov>
References: <4DB92ED0.4050907@dev.mellanox.co.il>
	<4DB97EDA.6030104@dev.mellanox.co.il>
	<4DBCFDA9.4040903@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DBCFDA9.4040903-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Dorfman <elido-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 30 Apr 2011 23:28:57 -0700
Eli Dorfman <elido-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 04/28/2011 05:51 PM, Hal Rosenstock wrote:
> > On 4/28/2011 5:09 AM, Eli Dorfman wrote:
> >> Fixed general info query
> >>
> >> There was no output when query succeeded
> > 
> > Do you mean failed ?
> 
> No I meant succeeded.
> Since the IBERROR was missing the print of GeneralInfo is skipped.
> If it fails then the "if (general_info)" code is reached but it will print garbage.

Thanks applied,
Ira

> 
> Eli
> 
> > 
> > -- Hal
> > 
> >>
> >> Signed-off-by: Eli Dorfman <elido-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> ---
> >>  src/vendstat.c |    1 +
> >>  1 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/src/vendstat.c b/src/vendstat.c
> >> index 92a90c8..8dbd1ee 100644
> >> --- a/src/vendstat.c
> >> +++ b/src/vendstat.c
> >> @@ -375,6 +375,7 @@ int main(int argc, char **argv)
> >>  	gi = (is3_general_info_t *) & buf;
> >>  	if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
> >>  		      IB_MLX_IS3_GENERAL_INFO, 0, gi))
> >> +		IBERROR("generalinfo query");
> >>  
> >>  	if (general_info) {
> >>  		/* dump IS3 or IS4 general info here */
> > 
> 


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
