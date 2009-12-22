From: Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>
Subject: Re: Proposal to add a name to an IB subnet
Date: Mon, 21 Dec 2009 16:14:31 -0800
Message-ID: <4B300F67.60105@sgi.com>
References: <4B16FF44.7090507@sgi.com> <f0e08f230912210559s4e011adendf10b489a0ad7c8c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f230912210559s4e011adendf10b489a0ad7c8c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hal Rosenstock wrote:
> On Wed, Dec 2, 2009 at 6:59 PM, Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org> wrote:
>> Hi,
>>
>> I suggest we add a text based name to an IB subnet, perhaps to
>> help user in identifying an IB subnet or understanding its function
>> in a multi-fabric IB cluster. For example, in a dual-fabric
>> (or dual-rail) IB cluster, one subnet could be named "mpi" and the
>> other subnet could be named "storage".
>>
>> In the current implementation of OpenSM, syslog messages are prefixed
>> with the process ID. When multiple instances of OpenSM run on a single node
>> to support dual-fabric IB, process ID doesn't help the admin to quickly
>> identify a specific IB subnet (i.e., it needs a translation)
>>
>> subnet_prefix (64-bit number) can be used as a prefix to syslog messages
>> but a user configurable text based name is better.
>>
>> We could add an option '-n | --ib_subnet_name' to OpenSM command line
>> to input the IB subnet name and modify the osm_log() function for syslog
>> messages (message type: OSM_LOG_SYS) to prefix its messages with the
>> subnet name.
> 
> Support for this could/should be added in the options file as well.
> 
> -- Hal

Sure. We can add the variable name/value "ib_subnet_name" to options file as well.

Regards,
Benjamin

> 
>> Also, we could limit this name prefix changes to syslog messages only for now.
>> (i.e., leave the opensm log as it is because the current implementation
>> allows the user to specify the file name for the opensm log)
>>
>> Any comments?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
