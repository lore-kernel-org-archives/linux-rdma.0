From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] ibsim: allocate mft according to number of switch ports
Date: Mon, 03 Mar 2014 08:22:06 -0500
Message-ID: <531481FE.6000204@dev.mellanox.co.il>
References: <danielk@mellanox.com> <1393505316-31115-1-git-send-email-danielk@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393505316-31115-1-git-send-email-danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/27/2014 7:48 AM, Daniel Klein wrote:
> From: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> 
> calculate number of port masks according to number of switch ports
> and allocate MFT accordingly
> 
> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  ibsim/sim.h     |    5 ++---
>  ibsim/sim_mad.c |    5 +++--
>  ibsim/sim_net.c |    5 +++--
>  3 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/ibsim/sim.h b/ibsim/sim.h
> index daeecec..6b33a2c 100644
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
> @@ -318,6 +316,7 @@ struct Switch {
>  	int linearFDBtop;
>  	int portchange;
>  	int lifetime;
> +	int numportmask;
>  	uint8_t switchinfo[64];
>  	Node *node;
>  	uint8_t *fdb;
> diff --git a/ibsim/sim_mad.c b/ibsim/sim_mad.c
> index 223d507..d851aa8 100644
> --- a/ibsim/sim_mad.c
> +++ b/ibsim/sim_mad.c
> @@ -532,18 +532,19 @@ static int do_multicastforwtbl(Port * port, unsigned op, uint32_t mod,
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

Why not just:
	if (numBlock32 > LASTBLOCK32 || numPortMsk > sw->numportmask) {
?

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
> index 10820ba..fe4687a 100644
> --- a/ibsim/sim_net.c
> +++ b/ibsim/sim_net.c
> @@ -245,6 +245,7 @@ static Switch *new_switch(Node * nd, int set_esp0)
>  	sw->node = nd;
>  	sw->linearcap = maxlinearcap;	// assume identical val for all switches
>  	sw->multicastcap = maxmcastcap;	// assume identical val for all switches
> +	sw->numportmask = (nd->numports + MCASTMASKSIZE) / MCASTMASKSIZE;

Doesn't this cause extra portmask when number of switch ports is modulo 16 ?

Shouldn't this be:
	sw->numportmask = (nd->numports + MCASTMASKSIZE - 1) / MCASTMASKSIZE;
?

-- Hal

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
