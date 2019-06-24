From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v3 1/2] ipaddress: correctly print a VF hw
 address in the IPoIB case
Date: Mon, 24 Jun 2019 11:59:04 -0600
Message-ID: <a669939c-d8f3-f3c8-15f4-efa236e00954@gmail.com>
References: <20190622180035.40245-1-dkirjanov@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190622180035.40245-1-dkirjanov@suse.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Denis Kirjanov <kda@linux-powerpc.org>, stephen@networkplumber.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dledford@redhat.com, mkubecek@suse.cz
List-Id: linux-rdma@vger.kernel.org

On 6/22/19 12:00 PM, Denis Kirjanov wrote:
> @@ -365,13 +367,45 @@ static void print_vfinfo(FILE *fp, struct rtattr *vfinfo)
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
> +					ifi->ifi_type == ARPHRD_ETHER ?
> +					ETH_ALEN : INFINIBAND_ALEN,
> +					ifi->ifi_type,
> +					b1, sizeof(b1)));

you still have a lot of lines that are not lined up column wise. See how
the COLOR_MAC is offset to the right from PRINT_ANY?

> +
> +	if (vf[IFLA_VF_BROADCAST]) {
> +		if (ifi->ifi_flags&IFF_POINTOPOINT) {
> +			print_string(PRINT_FP, NULL, " peer ", NULL);
> +			print_bool(PRINT_JSON,
> +					"link_pointtopoint", NULL, true);
> +		} else
> +			print_string(PRINT_FP, NULL, " brd ", NULL);
> +
> +		print_color_string(PRINT_ANY,
> +				COLOR_MAC,
> +				"broadcast",
> +				"%s",
> +				ll_addr_n2a((unsigned char *) &vf_broadcast->broadcast,
> +					ifi->ifi_type == ARPHRD_ETHER ?
> +					ETH_ALEN : INFINIBAND_ALEN,
> +					ifi->ifi_type,
> +					b1, sizeof(b1)));

And then these lines are offset to the left.
