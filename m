From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 05/14] IB/srp: Maintain a single connection per I_T nexus
Date: Thu, 13 Jun 2013 17:07:50 +0200
Message-ID: <51B9E046.3030008@acm.org>
References: <51B87501.4070005@acm.org> <51B876BF.4070400@acm.org> <51B9CFC3.8080008@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B9CFC3.8080008-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/13/13 15:57, Sebastian Riemer wrote:
> You've only changed the style of this function. Functionality is still
> the same. Fine for me.
> 
> But why do you put it that high in the source code?
> Do you (still) need it for something else?
> 
> I would put it directly in front of srp_create_target() or even in front
> of that option parsing stuff for correct bottom-up.

Good idea. Will move the definition of that function down.
 
>>   static int srp_connect_target(struct srp_target_port *target)
>>   {
>>   	int retries = 3;
>> @@ -2261,6 +2291,14 @@ static ssize_t srp_create_target(struct device *dev,
>>   	if (ret)
>>   		goto err;
>>   
>> +	if (!srp_conn_unique(target->srp_host, target)) {
>> +		shost_printk(KERN_INFO, target->scsi_host,
>> +			     PFX "Already connected to target port %.*s\n",
>> +			     (int)count, buf);
>> +		ret = -EEXIST;
>> +		goto err;
>> +	}
>> +
> 
> Yes, this looks good! Nice idea to print the connection string!
> Would be even cooler without trailing '\n' from within 'buf' but that's
> okay.
> 
> I was a little bit afraid of overflows here so I did security testing.
> But srp_parse_options() already rejected my evil connection strings. :-)
> 
> I've tried things like this:
> id_ext=0002c903004ed0b2,\
> ioc_guid=0002c903004ed0b2,\
> dgid=fe800000000000000002c903004ed0b4,\
> pkey=ffff,service_id=0002c903004ed0b2,\
> xxxxxxxxxxxxxxxxxxxxxxxxx... until 4096 chars
> 
> id_ext=0002c903004ed0b2,\
> ioc_guid=0002c903004ed0b2,\
> dgid=fe800000000000000002c903004ed0b4,\
> pkey=ffff,service_id=0002c903004ed0b2,\
> id_ext=0002c903004ed0b2,\
> ioc_guid=0002c903004ed0b2,\
> dgid=fe800000000000000002c903004ed0b4,\
> pkey=ffff,service_id=0002c903004ed0b2,\
> ... until 4096 chars
> 
> This string looked kind of funny. Also in the kernel message it was a
> little bit longer than usual but the parsing detected that I have too
> many parameters. So everything is fine in terms of security.

The "%.*s" should only copy the data provided by the user, even if it
is not '\0' terminated. Stripping the trailing newline is probably
possible with something like the (untested) code below (will only work
if there is only one newline in the input string and if it's at the
end):
		shost_printk(KERN_INFO, target->scsi_host,
			     PFX "Already connected to target port %.*s\n",
			     (int)count - (memchr(buf, '\n', count) ==
					   buf + count - 1), buf);

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
