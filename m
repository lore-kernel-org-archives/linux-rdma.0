From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH librdmacm] rsocket: Add support for RDMA_ROUTE option
 in rgetsockopt
Date: Thu, 19 Jun 2014 11:52:33 -0400
Message-ID: <53A30741.50908@dev.mellanox.co.il>
References: <53A2DC3A.8050204@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237399312AB2@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399312AB2-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/19/2014 11:29 AM, Hefty, Sean wrote:
>> +		case RDMA_ROUTE:
>> +			if (*optlen < sizeof(path_data)) {
>> +				ret = EINVAL;
>> +			} else {
>> +				len = 0;
>> +				opt = optval;
>> +				path_rec = rs->cm_id->route.path_rec;
>> +				num_paths = 0;
>> +				if (len + sizeof(path_data) <= *optlen &&
> 
> len is 0 here and we've already checked *optlen
> 
>> +				    num_paths < rs->cm_id->route.num_paths) {
> 
> and num_paths is 0
> 
>> +					rs_convert_sa_path(path_rec, &path_data);
>> +					memcpy(opt, &path_data, sizeof(path_data));
>> +					len += sizeof(path_data);
>> +					opt += sizeof(path_data);
>> +					path_rec++;
>> +					num_paths++;
> 
> were you actually wanting a loop here?

Yes; if should have been while

> 
>> +				}
> 
> This also needs to handle the case where rgetsockopt is called immediately after rsetsockopt.  Something like:
> 
> if (rs->optval) {
> 	memcpy(rs->optval, optval, rs->optlen);
> 	*optlen = rs->optlen;
> }
> 
> assuming that rs->optlen is verified

Sure.

v2 patch shortly...

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
