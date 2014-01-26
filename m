From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH infiniband-diags] libibnetdisc/ibnetdisc.c: improve log
 information to stdout
Date: Sun, 26 Jan 2014 06:04:13 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04ADDE87@CRSMSX101.amr.corp.intel.com>
References: <20140102064415.GA4568@r-ufm96.mtr.labs.mlnx>
 <2807E5FD2F6FDA4886F6618EAC48510E04A94D41@CRSMSX101.amr.corp.intel.com>
 <20140119081953.GB26599@r-ufm96.mtr.labs.mlnx>
 <2807E5FD2F6FDA4886F6618EAC48510E04ADA47A@CRSMSX101.amr.corp.intel.com>
 <52E3D812.9030009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52E3D812.9030009-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >>>
> >>> As part of a library this will affect many tools outputs and perhaps
> >> subsequently any scripts written against those tools.
> >>>
> >>> Is this really a requirement or simply a "nice to have"?
> >> That was a customer request to get the query path to stdout when
> >> getting an error.
> >>
> >> This way when getting smp error they could see DR path to the node in
> >> stdout.
> >
> > I think this is ok,
> 
> Doesn't this change the ibnetdiscover output file format when such errors
> are encountered ?

yes

> 
> If so, what happens in terms of tools which parse this ?

They may break.

> 
> Should IBND_INFO output be prepended with "# " as that would be safer in
> terms of sticking within current output file definition and provides such
> feature ?

At first, I thought this would be a good compromise but I looked back before libibnetdisc was created and I see no indication that "# " prefixed errors in ibnetdiscover back then.  It appears that all errors have always gone to stderr AFAICS.

I understand the issues with users not seeing any indication of error in their output.  But this really is a mistake and I should not have accepted this patch as submitted.

I'm sorry Dan, I'm reverting the patch and re-releasing for the upcoming OFED.

I think there are 2 solutions for this.

1) users can direct stderr to stdout to capture all the output
2) I'd be open to a patch which adds an option to the library to allow the user to add error output to stdout.

Sorry for the confusion,
Ira

> 
> -- Hal
> 
> > applied thanks,
> > Ira
> >
> >>
> >> -- Dan
> >>
> >>>
> >>> Ira
> >>>
> >>>>
> >>>> Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>>> ---
> >>>>  libibnetdisc/src/internal.h  |   10 +++++++---
> >>>>  libibnetdisc/src/query_smp.c |    6 ++++++
> >>>>  2 files changed, 13 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/libibnetdisc/src/internal.h
> >>>> b/libibnetdisc/src/internal.h index 1ccd29c..47b2a4c 100644
> >>>> --- a/libibnetdisc/src/internal.h
> >>>> +++ b/libibnetdisc/src/internal.h
> >>>> @@ -42,12 +42,16 @@
> >>>>  #include <complib/cl_qmap.h>
> >>>>  #include <glib.h>
> >>>>
> >>>> +#define	IBND_ERROR(fmt, ...) \
> >>>> +		fprintf(stderr, "%s:%u; " fmt, __FILE__, __LINE__, ##
> >>>> __VA_ARGS__)
> >>>> +
> >>>> +#define	IBND_INFO(fmt, ...) \
> >>>> +		printf("%s:%u; " fmt, __FILE__, __LINE__, ##
> >>>> __VA_ARGS__);
> >>>> +
> >>>>  #define	IBND_DEBUG(fmt, ...) \
> >>>>  	if (ibdebug) { \
> >>>> -		printf("%s:%u; " fmt, __FILE__, __LINE__, ##
> >>>> __VA_ARGS__); \
> >>>> +		IBND_INFO(fmt,## __VA_ARGS__); \
> >>>>  	}
> >>>> -#define	IBND_ERROR(fmt, ...) \
> >>>> -		fprintf(stderr, "%s:%u; " fmt, __FILE__, __LINE__, ##
> >>>> __VA_ARGS__)
> >>>>
> >>>>  /* HASH table defines */
> >>>>  #define HASHGUID(guid) ((uint32_t)(((uint32_t)(guid) * 101) ^
> >>>> ((uint32_t)((guid) >> 32) * 103))) diff --git
> >>>> a/libibnetdisc/src/query_smp.c b/libibnetdisc/src/query_smp.c index
> >>>> 28620b4..ac4984e 100644
> >>>> --- a/libibnetdisc/src/query_smp.c
> >>>> +++ b/libibnetdisc/src/query_smp.c
> >>>> @@ -192,6 +192,9 @@ static int process_one_recv(smp_engine_t *
> >> engine)
> >>>>  		goto error;
> >>>>
> >>>>  	if ((status = umad_status(umad))) {
> >>>> +		IBND_INFO("umad (%s Attr 0x%x:%u) bad status %d; %s\n",
> >>>> +			   portid2str(&smp->path), smp->rpc.attr.id,
> >>>> +			   smp->rpc.attr.mod, status, strerror(status));
> >>>>  		IBND_ERROR("umad (%s Attr 0x%x:%u) bad status %d;
> >> %s\n",
> >>>>  			   portid2str(&smp->path), smp->rpc.attr.id,
> >>>>  			   smp->rpc.attr.mod, status, strerror(status)); @@ -
> >>>> 199,6 +202,9 @@ static int process_one_recv(smp_engine_t * engine)
> >>>>  			rc = mlnx_ext_port_info_err(engine, smp, mad,
> >>>>  						    smp->cb_data);
> >>>>  	} else if ((status = mad_get_field(mad, 0, IB_DRSMP_STATUS_F))) {
> >>>> +		IBND_INFO("mad (%s Attr 0x%x:%u) bad status 0x%x\n",
> >>>> +			   portid2str(&smp->path), smp->rpc.attr.id,
> >>>> +			   smp->rpc.attr.mod, status);
> >>>>  		IBND_ERROR("mad (%s Attr 0x%x:%u) bad status 0x%x\n",
> >>>>  			   portid2str(&smp->path), smp->rpc.attr.id,
> >>>>  			   smp->rpc.attr.mod, status);
> >>>> --
> >>>> 1.7.1
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> >>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> >> majordomo
> >>> info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
