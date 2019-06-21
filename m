From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v2 1/2] ipaddress: correctly print a VF hw
 address in the IPoIB case
Date: Fri, 21 Jun 2019 16:56:09 -0600
Message-ID: <68e73778-a739-4337-0e48-280483a73569@gmail.com>
References: <20190620090249.106704-1-dkirjanov@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190620090249.106704-1-dkirjanov@suse.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Denis Kirjanov <kda@linux-powerpc.org>, stephen@networkplumber.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dledford@redhat.com, mkubecek@suse.cz
List-Id: linux-rdma@vger.kernel.org

On 6/20/19 3:02 AM, Denis Kirjanov wrote:
> @@ -349,9 +350,10 @@ static void print_af_spec(FILE *fp, struct rtattr *af_spec_attr)
>  
>  static void print_vf_stats64(FILE *fp, struct rtattr *vfstats);
>  
> -static void print_vfinfo(FILE *fp, struct rtattr *vfinfo)
> +static void print_vfinfo(struct ifinfomsg *ifi, FILE *fp, struct rtattr *vfinfo)
>  {
>  	struct ifla_vf_mac *vf_mac;
> +	struct ifla_vf_broadcast *vf_broadcast;
>  	struct ifla_vf_tx_rate *vf_tx_rate;
>  	struct rtattr *vf[IFLA_VF_MAX + 1] = {};
>  
> @@ -365,13 +367,43 @@ static void print_vfinfo(FILE *fp, struct rtattr *vfinfo)
>  	parse_rtattr_nested(vf, IFLA_VF_MAX, vfinfo);
>  
>  	vf_mac = RTA_DATA(vf[IFLA_VF_MAC]);
> +	vf_broadcast = RTA_DATA(vf[IFLA_VF_BROADCAST]);
>  	vf_tx_rate = RTA_DATA(vf[IFLA_VF_TX_RATE]);
>  
>  	print_string(PRINT_FP, NULL, "%s    ", _SL_);
>  	print_int(PRINT_ANY, "vf", "vf %d ", vf_mac->vf);
> -	print_string(PRINT_ANY, "mac", "MAC %s",
> -		     ll_addr_n2a((unsigned char *) &vf_mac->mac,
> -				 ETH_ALEN, 0, b1, sizeof(b1)));
> +
> +	print_string(PRINT_ANY,
> +			"link_type",
> +			"    link/%s ",
> +			ll_type_n2a(ifi->ifi_type, b1, sizeof(b1)));
> +
> +	print_color_string(PRINT_ANY,
> +				COLOR_MAC,
> +				"address",
> +				"%s",
> +				ll_addr_n2a((unsigned char *) &vf_mac->mac,
> +					ifi->ifi_type == ARPHRD_ETHER ? ETH_ALEN : INFINIBAND_ALEN,
> +					ifi->ifi_type,
> +					b1, sizeof(b1)));
> +
> +	if (vf[IFLA_VF_BROADCAST]) {
> +		if (ifi->ifi_flags&IFF_POINTOPOINT) {
> +			print_string(PRINT_FP, NULL, " peer ", NULL);
> +			print_bool(PRINT_JSON,
> +					"link_pointtopoint", NULL, true);
> +                        } else {
> +				print_string(PRINT_FP, NULL, " brd ", NULL);
> +                        }
> +                        print_color_string(PRINT_ANY,
> +                                           COLOR_MAC,
> +                                           "broadcast",
> +                                           "%s",
> +                                           ll_addr_n2a((unsigned char *) &vf_broadcast->broadcast,
> +                                                       ifi->ifi_type == ARPHRD_ETHER ? ETH_ALEN : INFINIBAND_ALEN,
> +                                                       ifi->ifi_type,
> +                                                       b1, sizeof(b1)));
> +	}
>  

you have a number of alignment problems with the above changes. you can
run checkpatch from the kernel repo on it to verify the coding standards.
