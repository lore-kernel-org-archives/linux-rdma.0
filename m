From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 1/5] infiniband-diags/ibportstate.c: Support MKey,
 lease, and protect bits
Date: Tue, 24 Apr 2012 10:16:30 -0400
Message-ID: <4F96B5BE.4060903@dev.mellanox.co.il>
References: <1335228837.17237.302.camel@auk75.llnl.gov> <1335229017-10677-1-git-send-email-foraker1@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335229017-10677-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, weiny2-i2BcT+NCU+M@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/23/2012 8:56 PM, Jim Foraker wrote:
> Allow user to both display and change mkey-related values.
> 
> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> ---
>  src/ibportstate.c |   98 ++++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 79 insertions(+), 19 deletions(-)
> 
> diff --git a/src/ibportstate.c b/src/ibportstate.c
> index 5559d18..21cd431 100644
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
> @@ -142,7 +152,7 @@ static int get_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
>  }
>  
>  static void show_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
> -			   int espeed_cap)
> +			   int espeed_cap, int is_switch)
>  {
>  	char buf[2300];
>  	char val[64];
> @@ -201,18 +211,32 @@ static void show_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
>  			       val);
>  		sprintf(buf + strlen(buf), "%s", "\n");
>  	}
> +	if (!is_switch || portnum == 0) {
> +		mad_decode_field(data, IB_PORT_MKEY_F, val);
> +		mad_dump_field(IB_PORT_MKEY_F, buf + strlen(buf),
> +			       sizeof buf - strlen(buf), val);
> +		sprintf(buf+strlen(buf), "%s", "\n");
> +		mad_decode_field(data, IB_PORT_MKEY_LEASE_F, val);
> +		mad_dump_field(IB_PORT_MKEY_LEASE_F, buf + strlen(buf),
> +			       sizeof buf - strlen(buf), val);
> +		sprintf(buf+strlen(buf), "%s", "\n");
> +		mad_decode_field(data, IB_PORT_MKEY_PROT_BITS_F, val);
> +		mad_dump_field(IB_PORT_MKEY_PROT_BITS_F, buf + strlen(buf),
> +			       sizeof buf - strlen(buf), val);
> +		sprintf(buf+strlen(buf), "%s", "\n");
> +	}

Don't we want to be careful about displaying mkey info ? I think by
default it shouldn't be displayed and require an additional
option to make it visible which defaults not to do this.

-- Hal

>  
>  	printf("# Port info: %s port %d\n%s", portid2str(dest), portnum, buf);
>  }
>  
>  static void set_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
> -			  int espeed_cap)
> +			  int espeed_cap, int is_switch)
>  {
>  	if (!smp_set_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
>  		IBERROR("smp set portinfo failed");
>  
>  	printf("\nAfter PortInfo set:\n");
> -	show_port_info(dest, data, portnum, espeed_cap);
> +	show_port_info(dest, data, portnum, espeed_cap, is_switch);
>  }
>  
>  static void get_ext_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
> @@ -349,9 +373,10 @@ int main(int argc, char **argv)
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
> @@ -403,7 +428,7 @@ int main(int argc, char **argv)
>  			if (++i >= argc)
>  				IBERROR("%s requires an additional parameter",
>  					port_args[j].name);
> -			val = strtol(argv[i], 0, 0);
> +			val = strtoull(argv[i], 0, 0);
>  			switch (j) {
>  			case SPEED:
>  				if (val < 0 || val > 15)
> @@ -441,8 +466,29 @@ int main(int argc, char **argv)
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
> @@ -455,12 +501,16 @@ int main(int argc, char **argv)
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
>  		printf("%s PortInfo:\n", is_switch ? "Switch" : "CA");
>  	espeed_cap = get_port_info(&portid, data, portnum, is_switch);
> -	show_port_info(&portid, data, portnum, espeed_cap);
> +	show_port_info(&portid, data, portnum, espeed_cap, is_switch);
>  	if (is_mlnx_ext_port_info_supported(devid)) {
>  		get_ext_port_info(&portid, data2, portnum);
>  		show_ext_port_info(&portid, data2, portnum);
> @@ -527,7 +577,17 @@ int main(int argc, char **argv)
>  				      fdr10);
>  			set_ext_port_info(&portid, data2, portnum);
>  		}
> -		set_port_info(&portid, data, portnum, is_switch);
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
> +		set_port_info(&portid, data, portnum, espeed_cap, is_switch);
>  
>  	} else if (is_switch && portnum) {
>  		/* Now, make sure PortState is Active */
> @@ -596,7 +656,7 @@ int main(int argc, char **argv)
>  				get_ext_port_info(&peerportid, data2,
>  						  peerlocalportnum);
>  			show_port_info(&peerportid, data, peerlocalportnum,
> -				       peer_espeed_cap);
> +				       peer_espeed_cap, is_peer_switch);
>  			if (is_mlnx_ext_port_info_supported(rem_devid))
>  				show_ext_port_info(&peerportid, data2,
>  						   peerlocalportnum);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
