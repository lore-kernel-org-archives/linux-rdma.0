From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Status of ECMP patch
Date: Fri, 20 Jul 2012 13:50:19 -0400
Message-ID: <50099A5B.7020208@dev.mellanox.co.il>
References: <6A4B9687-301F-492A-88E8-5AC5CBDA784E@lanl.gov> <16FC53E6-F78C-4193-B6A3-D194FA1EFF32@lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <16FC53E6-F78C-4193-B6A3-D194FA1EFF32-YOWKrPYUwWM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Susan Coulter <markus-YOWKrPYUwWM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Susan,

On 7/20/2012 1:30 PM, Susan Coulter wrote:
> Question:
> About 2 years ago I reported at the OFA Developers Workshop that the ecmp routing within MinHop does not equally distribute routes among the multiple paths.  That is, if 4 different ports at one hop all result in an equal number of hops thru the rest of the fabric, the routes are not distributed equally among those 4 ports/paths.
> 
> I was told there were 2 different approaches to solve this and patches had been discussed/submitted and the community was deciding on a path forward.
> 
> Does anyone know the status of this?

The two approaches are:
1. Scatter ports (from Jared Carr)
2. Port shifting (from Al Chu)

and both have been upstream since April 2011.

-- Hal

> My apologies if the data is out there somewhere and I simply cannot find it.
> 
> Thanx in advance.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
