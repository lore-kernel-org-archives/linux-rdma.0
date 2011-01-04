From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] ibsim: allocate mft according to number of switch
 ports
Date: Tue, 4 Jan 2011 14:39:18 +0200
Message-ID: <4D2314F6.1060902@gmail.com>
References: <4C8E1470.8070106@gmail.com> <4C90B424.4060104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C90B424.4060104-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha,

It seems that you've missed this patch.
Please apply.

Thanks,
Eli

Eli Dorfman (Voltaire) wrote:
> allocate mft according to number of switch ports
> 
> calculate number of port masks according to number of switch ports
> and allocate MFT accordingly
> 
> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
>  ibsim/sim.h     |    5 ++---
>  ibsim/sim_mad.c |    5 +++--
>  ibsim/sim_net.c |    5 +++--
>  3 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/ibsim/sim.h b/ibsim/sim.h
> index 30f5075..c4ee11f 100644
> --- a/ibsim/sim.h
> +++ b/ibsim/sim.h
> @@ -45,9 +45,7 @@
>  #define MAXLINEARCAP	(30*1024)
>  #define MAXMCASTCAP	1024
>  #define LASTBLOCK32	(MAXMCASTCAP/32-1)
> -// NUMBEROFPORTMASK means that 32port switches could only be build
> -#define	NUMBEROFPORTMASK 2
> -#define LASTPORTMASK	(NUMBEROFPORTMASK-1)
> +#define MCASTMASKSIZE    16
>  // linkwidth == 4X - must be one width only 1,2 or 8
>  #define LINKWIDTH_1x        1
>  #define LINKWIDTH_4x        2
> @@ -229,6 +227,7 @@ struct Switch {
>  	int linearFDBtop;
>  	int portchange;
>  	int lifetime;
> +	int numportmask;
>  	uint8_t switchinfo[64];
>  	Node *node;
>  	uint8_t *fdb;
> diff --git a/ibsim/sim_mad.c b/ibsim/sim_mad.c
> index 61d4866..3133bcf 100644
> --- a/ibsim/sim_mad.c
> +++ b/ibsim/sim_mad.c
> @@ -513,18 +513,19 @@ static int do_multicastforwtbl(Port * port, unsigned op, uint32_t mod,
>  	int blockposition;
>  
>  	Switch *sw = port->node->sw;
> +	int lastportmask = sw->numportmask + 1;
>  
>  	if (!sw)		// not a Switch?
>  		return ERR_ATTR_UNSUPPORTED;
>  
>  	VERB("requested : Block32 %d PortMask %d", numBlock32, numPortMsk);
> -	if (numBlock32 > LASTBLOCK32 || numPortMsk > LASTPORTMASK) {
> +	if (numBlock32 > LASTBLOCK32 || numPortMsk > lastportmask) {
>  		int8_t zeroblock[64] = { 0 };
>  		mad_set_array(data, 0, IB_MULTICAST_FORW_TBL_F, zeroblock);
>  		return 0;
>  	}
>  
> -	blockposition = (numBlock32 * NUMBEROFPORTMASK + numPortMsk) * 64;
> +	blockposition = (numBlock32 * sw->numportmask + numPortMsk) * 64;
>  	if (op == IB_MAD_METHOD_SET)
>  		mad_get_array(data, 0, IB_MULTICAST_FORW_TBL_F,
>  			      sw->mfdb + blockposition);
> diff --git a/ibsim/sim_net.c b/ibsim/sim_net.c
> index 13c3b8c..f17f0b9 100644
> --- a/ibsim/sim_net.c
> +++ b/ibsim/sim_net.c
> @@ -245,6 +245,7 @@ static Switch *new_switch(Node * nd, int set_esp0)
>  	sw->node = nd;
>  	sw->linearcap = maxlinearcap;	// assume identical val for all switches
>  	sw->multicastcap = maxmcastcap;	// assume identical val for all switches
> +	sw->numportmask = (nd->numports + MCASTMASKSIZE) / MCASTMASKSIZE;
>  	memcpy(sw->switchinfo, switchinfo, sizeof(sw->switchinfo));
>  	mad_set_field(sw->switchinfo, 0, IB_SW_LINEAR_FDB_CAP_F, sw->linearcap);
>  	mad_set_field(sw->switchinfo, 0, IB_SW_MCAST_FDB_CAP_F,
> @@ -253,13 +254,13 @@ static Switch *new_switch(Node * nd, int set_esp0)
>  		mad_set_field(sw->switchinfo, 0, IB_SW_ENHANCED_PORT0_F,
>  			      set_esp0 > 0);
>  	sw->fdb = malloc(maxlinearcap*sizeof(sw->fdb[0]));
> -	sw->mfdb = malloc(maxmcastcap*NUMBEROFPORTMASK*sizeof(uint16_t));
> +	sw->mfdb = malloc(maxmcastcap * sw->numportmask * sizeof(uint16_t));
>  	if (!sw->fdb || !sw->mfdb) {
>  		IBPANIC("new_switch: no mem: %m");
>  		return NULL;
>  	}
>  	memset(sw->fdb, 0xff, maxlinearcap*sizeof(sw->fdb[0]));
> -	memset(sw->mfdb, 0, maxmcastcap*NUMBEROFPORTMASK*sizeof(uint16_t));
> +	memset(sw->mfdb, 0, maxmcastcap * sw->numportmask * sizeof(uint16_t));
>  
>  	return sw;
>  }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
