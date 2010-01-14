From: Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Add huge page support to ibv_madvise_range()
Date: Thu, 14 Jan 2010 17:12:12 +0200
Message-ID: <4B4F344C.5060009@gmail.com>
References: <4B12AA78.7090401@gmail.com> <20100112142544.GA14861@mtls03>
Reply-To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100112142544.GA14861@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org, roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Eli,

Sorry fot the late response.

> If strtol() fails, you may return with an invalid, non zero value for
> huge page size. Maybe use some temporary variable to hold the
> intermediate result.

If strtol() fails, for any reason, we always return value <= 0 for huge page size.
This indicates that system's huge page size is unknown
and the second call to ibv_madvise_range_helper(), with huge page size,
will be skipped (as it supposed to be).

Thanks,
AlexV

Eli Cohen Wrote:
> On Sun, Nov 29, 2009 at 07:08:08PM +0200, Alex Vainman wrote:
>> +	p_hpage_val = strstr(buf, label);
>> +	if (!p_hpage_val) {
>> +		errno = EINVAL;
>> +		return -1;
>> +	}
>> +	p_hpage_val += strlen(label);
>> +
>> +	errno = 0;
>> +	ret_val = strtol(p_hpage_val, &end_pointer, 0);
> 
> If strtol() fails, you may return with an invalid, non zero value for
> huge page size. Maybe use some temporary variable to hold the
> intermediate result.
>> +
>> +	if (errno != 0)
>> +		return -1;
>> +
>> +	return ret_val * 1024;
>> +}
>> +
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
