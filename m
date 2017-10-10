From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 40/47] IB/qib: Make qib_inc_eeprom_err() macro more safe
 to use
Date: Tue, 10 Oct 2017 14:15:10 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC3442AAD2@fmsmsx120.amr.corp.intel.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-41-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-41-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH 40/47] IB/qib: Make qib_inc_eeprom_err() macro more safe
> to use
> 
> Avoid that using the qib_inc_eeprom_err() macro in an if-statement
> triggers the following compiler warning:
> 
> warning: suggest braces around empty body in an 'if' statement [-Wempty-
> body]
> 

There needs to be a follow-on patch here to get rid of the uses of this macro.

The original fix got rid of a bad implementation, but should have totally removed both the function and its use.

The is not the fault of this patch.

Fixes: 18c0b82a3e45  (" IB/qib: Do not write EEPROM")
Acked-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
