From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH V3 5/8] infiniband-diags/ibportstate.c: Support changing
 MKey, lease, and protect bits
Date: Thu, 31 May 2012 15:21:39 -0700
Message-ID: <20120531152139.d7246bbd.weiny2@llnl.gov>
References: <1338398414.11948.29.camel@auk75.llnl.gov>
	<1338398497-12444-1-git-send-email-foraker1@llnl.gov>
	<1338398497-12444-5-git-send-email-foraker1@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338398497-12444-5-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 30 May 2012 10:21:34 -0700
Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org> wrote:

> 
> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>

Thanks, applied.
Ira

> ---
>  doc/rst/ibportstate.8.in.rst |    6 ++++
>  src/ibportstate.c            |   72 ++++++++++++++++++++++++++++++++++--------
>  2 files changed, 65 insertions(+), 13 deletions(-)
> 
> diff --git a/doc/rst/ibportstate.8.in.rst b/doc/rst/ibportstate.8.in.rst
> index fca3f7a..052e86a 100644
> --- a/doc/rst/ibportstate.8.in.rst
> +++ b/doc/rst/ibportstate.8.in.rst
> @@ -61,6 +61,12 @@ OPTIONS
>          done on a switch. This peer port validation feature of query op
>          requires LID routing to be functioning in the subnet.
>  
> +        **mkey, mkeylease, and mkeyprot** are only allowed on CAs, routers, or
> +        switch port 0 (An error is generated if attempted on external switch
> +        ports).  Hexadecimal and octal mkeys may be specified by prepending the
> +        key with '0x' or '0', respectively.  If a non-numeric value (like 'x')
> +        is specified for the mkey, then ibportstate will prompt for a value.
> +
>  
>  Addressing Flags
>  ----------------
> diff --git a/src/ibportstate.c b/src/ibportstate.c
> index 02cf333..743a276 100644
> --- a/src/ibportstate.c
> +++ b/src/ibportstate.c
> @@ -41,6 +41,7 @@
>  #include <unistd.h>
>  #include <string.h>
>  #include <getopt.h>
> +#include <errno.h>
>  
>  #include <infiniband/umad.h>
>  #include <infiniband/mad.h>
> @@ -64,22 +65,28 @@ enum port_ops {
>  	LID,
>  	SMLID,
>  	LMC,
> +	MKEY,
> +	MKEYLEASE,
> +	MKEYPROT,
>  };
>  
>  struct ibmad_port *srcport;
> -int speed = 0; /* no state change */
> -int espeed = 0; /* no state change */
> -int fdr10 = 0; /* no state change */
> -int width = 0; /* no state change */
> -int lid;
> -int smlid;
> -int lmc;
> -int mtu;
> -int vls = 0; /* no state change */
> +uint64_t speed = 0; /* no state change */
> +uint64_t espeed = 0; /* no state change */
> +uint64_t fdr10 = 0; /* no state change */
> +uint64_t width = 0; /* no state change */
> +uint64_t lid;
> +uint64_t smlid;
> +uint64_t lmc;
> +uint64_t mtu;
> +uint64_t vls = 0; /* no state change */
> +uint64_t mkey;
> +uint64_t mkeylease;
> +uint64_t mkeyprot;
>  
>  struct {
>  	const char *name;
> -	int *val;
> +	uint64_t *val;
>  	int set;
>  } port_args[] = {
>  	{"query", NULL, 0},	/* QUERY */
> @@ -98,6 +105,9 @@ struct {
>  	{"lid", &lid, 0},	/* LID */
>  	{"smlid", &smlid, 0},	/* SMLID */
>  	{"lmc", &lmc, 0},	/* LMC */
> +	{"mkey", &mkey, 0},	/* MKEY */
> +	{"mkeylease", &mkeylease, 0},	/* MKEY LEASE */
> +	{"mkeyprot", &mkeyprot, 0},	/* MKEY PROTECT BITS */
>  };
>  
>  #define NPORT_ARGS (sizeof(port_args) / sizeof(port_args[0]))
> @@ -367,9 +377,10 @@ int main(int argc, char **argv)
>  	int i;
>  	uint16_t devid, rem_devid;
>  	long val;
> +	char *endp;
>  	char usage_args[] = "<dest dr_path|lid|guid> <portnum> [<op>]\n"
>  	    "\nSupported ops: enable, disable, reset, speed, width, query,\n"
> -	    "\tdown, arm, active, vls, mtu, lid, smlid, lmc\n";
> +	    "\tdown, arm, active, vls, mtu, lid, smlid, lmc, mkey, mkeylease, mkeyprot\n";
>  	const char *usage_examples[] = {
>  		"3 1 disable\t\t\t# by lid",
>  		"-G 0x2C9000100D051 1 enable\t# by guid",
> @@ -423,7 +434,7 @@ int main(int argc, char **argv)
>  			if (++i >= argc)
>  				IBERROR("%s requires an additional parameter",
>  					port_args[j].name);
> -			val = strtol(argv[i], 0, 0);
> +			val = strtoull(argv[i], 0, 0);
>  			switch (j) {
>  			case SPEED:
>  				if (val < 0 || val > 15)
> @@ -461,8 +472,29 @@ int main(int argc, char **argv)
>  			case LMC:
>  				if (val < 0 || val > 7)
>  					IBERROR("invalid lmc value %ld", val);
> +				break;
> +			case MKEY:
> +				errno = 0;
> +				val = strtoull(argv[i], &endp, 0);
> +				if (errno || *endp != '\0') {
> +					errno = 0;
> +					val = strtoull(getpass("New M_Key: "),
> +						       &endp, 0);
> +					if (errno || *endp != '\0') {
> +						IBERROR("Bad new M_Key\n");
> +					}
> +				}
> +				/* All 64-bit values are legal */
> +				break;
> +			case MKEYLEASE:
> +				if (val < 0 || val > 0xFFFF)
> +					IBERROR("invalid mkey lease time %ld", val);
> +				break;
> +			case MKEYPROT:
> +				if (val < 0 || val > 3)
> +					IBERROR("invalid mkey protection bit setting %ld", val);
>  			}
> -			*port_args[j].val = (int)val;
> +			*port_args[j].val = val;
>  			changed = 1;
>  			break;
>  		}
> @@ -475,6 +507,10 @@ int main(int argc, char **argv)
>  	is_switch = get_node_info(&portid, data);
>  	devid = (uint16_t) mad_get_field(data, 0, IB_NODE_DEVID_F);
>  
> +	if ((port_args[MKEY].set || port_args[MKEYLEASE].set ||
> +	     port_args[MKEYPROT].set) && is_switch && portnum != 0)
> +		IBERROR("Can't set M_Key fields on switch port != 0");
> +
>  	if (port_op != QUERY || changed)
>  		printf("Initial %s PortInfo:\n", is_switch ? "Switch" : "CA");
>  	else
> @@ -547,6 +583,16 @@ int main(int argc, char **argv)
>  				      fdr10);
>  			set_ext_port_info(&portid, data2, portnum);
>  		}
> +
> +		if (port_args[MKEY].set)
> +			mad_set_field64(data, 0, IB_PORT_MKEY_F, mkey);
> +		if (port_args[MKEYLEASE].set)
> +			mad_set_field(data, 0, IB_PORT_MKEY_LEASE_F,
> +				      mkeylease);
> +		if (port_args[MKEYPROT].set)
> +			mad_set_field(data, 0, IB_PORT_MKEY_PROT_BITS_F,
> +				      mkeyprot);
> +
>  		set_port_info(&portid, data, portnum, espeed_cap, is_switch);
>  
>  	} else if (is_switch && portnum) {
> -- 
> 1.7.9.2
> 


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
