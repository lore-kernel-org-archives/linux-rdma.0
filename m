From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: libibnetdisc: Add grouping for Voltaire's ISR4700 switch
Date: Fri, 7 May 2010 01:27:18 +0300
Message-ID: <20100506222718.GL7099@me.iol.unh.edu>
References: <20100427143529.75d64f9f@frecb007965>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100427143529.75d64f9f@frecb007965>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Cc: Yair Goldel <yairg-smomgflXvOZWk0Htik3J/w@public.gmane.org>, OF EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14:35 Tue 27 Apr     , sebastien dugue wrote:
> 
>   The ISR4700 features 3 kind of boards:
>     
>   - sLB-4018 line board with a single 36 port asic
>   - sFB-4700 fabric board with a single 36 port asic
>   - sFB-4700X2 double density fabric board with 2 36 port asics
>     
>   The double density fabric board (sFB-4700X2) features external 12X
> connectors that are only an aggregation of 3 4X ports, therefore
> ext_portnum is set to match the number printed on the faceplate.
>     
> Signed-off-by: Sebastien Dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
