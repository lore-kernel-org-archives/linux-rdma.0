From: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH] Add cleanup routines.
Date: Fri, 11 Apr 2014 19:46:12 +0200
Message-ID: <21ED5DCE-D13D-48B7-A2A7-3D690085E35D@gmx.net>
References: <A521BD06-7228-4FA9-97DD-7DFA51BE7505@gmx.net> <1397235649.29001.19.camel@localhost.localdomain>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397235649.29001.19.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Am 11.04.2014 um 19:00 schrieb Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>:

> Hi,
Thanks for your quick reply.

> Please adds some explanation, in particular the purpose of the changes.
> Your commit message only explain "how", but you should also explain
> "why".
Ok.

> In C, empty prototype declare a function which accept any parameter. So
> perhaps void ibverbs(void) is what you mean.
Yup, thanks.

>> +{
>> +	size_t i;
>> +	for (i = 0; i < num_devices; i++) {
>> +		/* driver callback needed. May not be malloc'd memory */
> 
> Seems dangerous. Such interrogation must be explicitly added in the
> commit message. 
Maybe it's better to leave it as a TODO and only free the device_list
itself?

>> +	for (driver = head_driver; driver;) {
>> +		struct ibv_driver *tmp = driver;
>> +		driver = driver->next;
>> +		free(tmp);
>> +	}
>> +
> 
> Is it safe here to free the driver ?
The struct itself is no longer needed.  All the driver libraries are
loaded and ibverbs_init() is call-once, so no new libraries are
dlopen()ed (and call ibv_register_driver()).
It's probably nicer first to dlclose() all libraries and then free all
struct ibv_drivers.

>> +	for (list = so_list; list;) {
>> +		struct ibv_so_list *tmp = list;
>> +		list = list->next;
>> +		dlclose(tmp->dlhandle);
>> +		free(tmp);
>> +	}
>> +}
> 
> Why not store the dlopen() handle in the struct ibv_driver itself ?
> This way only one list has to be scanned.
That was my first idea, but the struct ibv_driver doesn't exist at
that time.  First the (driver) library is dlopen()d and calls
ibv_register_driver().  Only there is the ibv_driver struct allocated,
but the handle is gone.

Best regards,
Hannes
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
