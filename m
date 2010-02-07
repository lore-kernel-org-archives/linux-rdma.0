From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: bug 1918 - openmpi broken due to rdma-cm changes
Date: Sat, 6 Feb 2010 16:12:46 -0800
Message-ID: <B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com> <0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com> <4B6C498F.3060708@opengridcomputing.com> <38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com> <4B6D9948.6040007@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6D9948.6040007-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "'Jeff Squyres (jsquyres)'" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> -	list_for_each_entry(cma_dev, &dev_list, list)
>> +	list_for_each_entry(cma_dev, &dev_list, list) {
>> +		if (rdma_node_get_transport(cma_dev->device->node_type) !=
>> +		    RDMA_TRANSPORT_IB)
>> +			continue;
>> +
>>  		for (p = 1; p <= cma_dev->device->phys_port_cnt; ++p)
>>  			if (!ib_query_port(cma_dev->device, p, &port_attr) &&
>>  			    port_attr.state == IB_PORT_ACTIVE)
>>  				goto port_found;
>> +	}
>>
>
>Here you need to:
>                    ret = -ENODEV;
>                    goto out;

Good catch, I'll update the patch and submit for 2.6.33 on Monday.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
