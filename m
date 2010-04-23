From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH v3 1/2] libibnetdisc: Convert to a multi-smp algorithm
Date: Thu, 22 Apr 2010 19:12:31 -0700
Message-ID: <20100422191231.bf6021fb.weiny2@llnl.gov>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
	<20100413104658.GA10830@me>
	<20100413132531.GI10830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100413132531.GI10830@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 13 Apr 2010 16:25:31 +0300
Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> On 13:46 Tue 13 Apr     , Sasha Khapyorsky wrote:
> > 
> > However see some comments and questions below.
> 
> Another thought. What about API like:
> 
> 	ibnd_discover_fabric(cosnt char *ca_name, unsigned port_num,
> 			     struct ibnd_config *cfg);
> 
> So libibnetdisc will be responsible for opening and closing its own port
> and in this way will be fully reenterable?

I think we need this...  But this alone will not fix ibnetdisc...

I found out why "iblinkinfo -S" is hanging for me.  The new algorithm has the
library using both libibmad and libibumad calls simultaneously.

These libraries were not designed to be used this way.  Therefore, I don't
think there is any direct bug in those layers.  However, this is why I thought
it was better for ibnetdisc to sit on top of ibmad and not use the umad layer.

Anyway, I think it is a mistake to pass an ibmad_port construct directly to
this library now.  Here is why.

umad_recv in query_smp.c and ib_resolve_self_via in ibnetdisc.c conflicted.
The underlying call to _do_madrpc was discarding the response MAD which
query_smp.c:umad_recv was expecting.  This would result in a hang forever.[*]
This will not happen unless you use -S because -S causes ibnetdisc.c to call
ib_resolve_self_via to determine the "drslid".  Basically ibnetdisc needs to
open an ibmad_port for any libibmad call and a fd via umad_open_port for the
parallel stuff.[#]

If we change the API to specify the ca name and port then the library can open
2 ports (or as many as it wants) and use them appropriately.  I think this is
the only solution which does not involve fixing libibmad.

So what about something like this:

   int ibnd_discover_fabric(ibnd_fabric_t **fabric,
			    cosnt char *ca_name,  <== could we even default this?
			    struct ibnd_config *cfg);

I don't mind the ibnd_config_t struct but I don't think it should be visible
to the user.  Make it opaque and use "set" functions.  Something like.

ibnd_fabric_t *fabric;
ibnd_config_t cfg;
ib_portid_t * from;

ibnd_set_hops(&cfg, hops);         <== default -1
ibnd_set_port_num(&cfg, port_num); <== default 1
ibnd_set_max_smps(&cfg, max_smps); <== default 2
ibnd_set_from_node(&cfg, from);    <== default NULL

if (ibnd_discover_fabric(&fabric, "foo", &cfg)) {  <== anything not in cfg is
                                                       defaulted here
   fprintf(stderr, "Wow it failed\n");
}

This allows us to change ibnd_config structure any time we want without
affecting the API.  I don't think the "pad" you used is a good idea.

Also since we are breaking the API we might as well return the fabric as a
parameter and have an error code.  But I could go either way on this one.

Ira


[*] query_smp.c probably should have it's own timeout here but we can discuss
later.

[#] What sucks about this is that libibmad already has the functionality to
open the umad port and configure it (50 line function).  Now we will be
duplicating this functionality.  I still maintain that making libibmad thread
safe would be very beneficial, if not necessary.  For example handling RMPP
and redirection is already in libibmad.  Why make people reimplement it on
their own if they want concurrent execution of any kind?  <sigh>


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
