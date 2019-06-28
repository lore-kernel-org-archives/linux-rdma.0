From: Denis Kirjanov <kda@linux-powerpc.org>
Subject: Re: [PATCH iproute2-next v3 1/2] ipaddress: correctly print a VF hw
 address in the IPoIB case
Date: Fri, 28 Jun 2019 11:56:34 +0300
Message-ID: <CAOJe8K33TOtnwbsw2vq6gGWOstrW-D-tC+kdHnTygmdCreSX6Q@mail.gmail.com>
References: <20190622180035.40245-1-dkirjanov@suse.com> <a669939c-d8f3-f3c8-15f4-efa236e00954@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <a669939c-d8f3-f3c8-15f4-efa236e00954@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dledford@redhat.com, mkubecek@suse.cz
List-Id: linux-rdma@vger.kernel.org

On 6/24/19, David Ahern <dsahern@gmail.com> wrote:
> On 6/22/19 12:00 PM, Denis Kirjanov wrote:
>> @@ -365,13 +367,45 @@ static void print_vfinfo(FILE *fp, struct rtattr
>> *vfinfo)
>>  	parse_rtattr_nested(vf, IFLA_VF_MAX, vfinfo);
>>
>>  	vf_mac = RTA_DATA(vf[IFLA_VF_MAC]);
>> +	vf_broadcast = RTA_DATA(vf[IFLA_VF_BROADCAST]);
>>  	vf_tx_rate = RTA_DATA(vf[IFLA_VF_TX_RATE]);
>>
>>  	print_string(PRINT_FP, NULL, "%s    ", _SL_);
>>  	print_int(PRINT_ANY, "vf", "vf %d ", vf_mac->vf);
>> -	print_string(PRINT_ANY, "mac", "MAC %s",
>> -		     ll_addr_n2a((unsigned char *) &vf_mac->mac,
>> -				 ETH_ALEN, 0, b1, sizeof(b1)));
>> +
>> +	print_string(PRINT_ANY,
>> +			"link_type",
>> +			"    link/%s ",
>> +			ll_type_n2a(ifi->ifi_type, b1, sizeof(b1)));
>> +
>> +	print_color_string(PRINT_ANY,
>> +				COLOR_MAC,
>> +				"address",
>> +				"%s",
>> +				ll_addr_n2a((unsigned char *) &vf_mac->mac,
>> +					ifi->ifi_type == ARPHRD_ETHER ?
>> +					ETH_ALEN : INFINIBAND_ALEN,
>> +					ifi->ifi_type,
>> +					b1, sizeof(b1)));
>
> you still have a lot of lines that are not lined up column wise. See how
> the COLOR_MAC is offset to the right from PRINT_ANY?
>
>> +
>> +	if (vf[IFLA_VF_BROADCAST]) {
>> +		if (ifi->ifi_flags&IFF_POINTOPOINT) {
>> +			print_string(PRINT_FP, NULL, " peer ", NULL);
>> +			print_bool(PRINT_JSON,
>> +					"link_pointtopoint", NULL, true);
>> +		} else
>> +			print_string(PRINT_FP, NULL, " brd ", NULL);
>> +
>> +		print_color_string(PRINT_ANY,
>> +				COLOR_MAC,
>> +				"broadcast",
>> +				"%s",
>> +				ll_addr_n2a((unsigned char *) &vf_broadcast->broadcast,
>> +					ifi->ifi_type == ARPHRD_ETHER ?
>> +					ETH_ALEN : INFINIBAND_ALEN,
>> +					ifi->ifi_type,
>> +					b1, sizeof(b1)));
>
> And then these lines are offset to the left.

Hi David,

I've just sent a new version and I've formatted strings in the similar
way as it used through the source.

Thank you.

>
