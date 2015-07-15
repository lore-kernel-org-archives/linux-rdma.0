From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 2/4 infiniband-diags] ibqueryerrors: Close global file
 descriptor before running ibnd_discover_fabric
Date: Wed, 15 Jul 2015 12:00:51 -0400
Message-ID: <55A683B3.1090000@dev.mellanox.co.il>
References: <553D3D9E.3020804@dev.mellanox.co.il> <20150703152421.GF15224@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150703152421.GF15224-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/3/2015 11:24 AM, ira.weiny wrote:
> On Sun, Apr 26, 2015 at 03:33:50PM -0400, Hal Rosenstock wrote:
>> From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Date: Sun, 26 Apr 2015 12:24:06 +0300
>>
>> Global file descriptor for SMPs and GMPs should be closed before running
>> ibnd_discover_fabric() to avoid parallel usage of two SMP file descriptors
>>
>> Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This patch made the goto labels misleading when reading the code.  I changed
> the name of the goto labels.

These label name changes look fine to me. Thanks.

-- Hal

> Please verify I did not break anything on your end.
> 
> Applied with fix ups to the goto labels.
> 
> Ira
> 
>> ---
>> Changes since v1:
>> Fixed direct route (-D) option
>>
>> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
>> index 06fcbac..80436d3 100644
>> --- a/src/ibqueryerrors.c
>> +++ b/src/ibqueryerrors.c
>> @@ -1000,18 +1002,20 @@ int main(int argc, char **argv)
>>  	config.flags = ibd_ibnetdisc_flags;
>>  	config.mkey = ibd_mkey;
>>  
>> -	node_name_map = open_node_name_map(node_name_map_file);
>> -
>>  	if (dr_path && load_cache_file) {
>> +		mad_rpc_close_port(ibmad_port);
>>  		fprintf(stderr, "Cannot specify cache and direct route path\n");
>>  		exit(-1);
>>  	}
>>  
>>  	if (resolve_self(ibd_ca, ibd_ca_port, &self_portid, &port, &self_gid.raw) < 0) {
>> +		mad_rpc_close_port(ibmad_port);
>>  		IBEXIT("can't resolve self port %s", argv[0]);
>>  		goto close_port;
>>  	}
>>  
>> +	node_name_map = open_node_name_map(node_name_map_file);
>> +
>>  	/* limit the scan the fabric around the target */
>>  	if (dr_path) {
>>  		if ((resolved =
>> @@ -1030,10 +1034,13 @@ int main(int argc, char **argv)
>>  			lid2sl_table[portid.lid] = portid.sl;
>>  	}
>>  
>> +	mad_rpc_close_port(ibmad_port);
>> +
>>  	if (load_cache_file) {
>>  		if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL) {
>>  			fprintf(stderr, "loading cached fabric failed\n");
>> -			exit(-1);
>> +			rc = -1;
>> +			goto close_port;
>>  		}
>>  	} else {
>>  		if (resolved >= 0) {
>> @@ -1057,6 +1064,21 @@ int main(int argc, char **argv)
>>  
>>  	set_thresholds(threshold_file);
>>  
>> +	/* reopen the global ibmad_port */
>> +	ibmad_port = mad_rpc_open_port(ibd_ca, ibd_ca_port,
>> +				       mgmt_classes, 4);
>> +	if (!ibmad_port) {
>> +		ibnd_destroy_fabric(fabric);
>> +		close_node_name_map(node_name_map);
>> +		IBEXIT("Failed to reopen port: %s:%d\n",
>> +			ibd_ca, ibd_ca_port);
>> +	}
>> +
>> +	smp_mkey_set(ibmad_port, ibd_mkey);
>> +
>> +	if (ibd_timeout)
>> +		mad_rpc_set_timeout(ibmad_port, ibd_timeout);
>> +
>>  	if (port_guid_str) {
>>  		ibnd_port_t *port = ibnd_find_port_guid(fabric, port_guid);
>>  		if (port)
>> @@ -1067,12 +1089,12 @@ int main(int argc, char **argv)
>>  	} else if (dr_path) {
>>  		ibnd_port_t *port = ibnd_find_port_dr(fabric, dr_path);
>>  		uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
>> -
>>  		if (!smp_query_via(ni, &portid, IB_ATTR_NODE_INFO, 0,
>> -				   ibd_timeout, ibmad_port)) {
>> -			rc = -1;
>> -			goto destroy_fabric;
>> +			   ibd_timeout, ibmad_port)) {
>> +				fprintf(stderr, "Failed to query local Node Info\n");
>> +				goto destroy_fabric;
>>  		}
>> +
>>  		mad_decode_field(ni, IB_NODE_PORT_GUID_F, &(port_guid));
>>  
>>  		port = ibnd_find_port_guid(fabric, port_guid);
>> @@ -1087,6 +1109,7 @@ int main(int argc, char **argv)
>>  		if(obtain_sl)
>>  			if(path_record_query(self_gid,0))
>>  				goto destroy_fabric;
>> +
>>  		ibnd_iter_nodes(fabric, print_node, NULL);
>>  	}
>>  
>> @@ -1095,10 +1118,10 @@ int main(int argc, char **argv)
>>  		rc = 1;
>>  
>>  destroy_fabric:
>> +	mad_rpc_close_port(ibmad_port);
>>  	ibnd_destroy_fabric(fabric);
>>  
>>  close_port:
>> -	mad_rpc_close_port(ibmad_port);
>>  	close_node_name_map(node_name_map);
>>  	exit(rc);
>>  }
>> -- 
>> 1.7.8.2
>>
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
