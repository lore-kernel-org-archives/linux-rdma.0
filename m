From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/ibqueryerrors: Add support for optional
	PortRcvErrorDetails counter
Date: Wed, 13 Jan 2010 15:10:41 -0500
Message-ID: <f0e08f231001131210r669265fax870cfb4bbaf3c1d@mail.gmail.com>
References: <20091231191054.GA27874@comcast.net> <20100112191420.GJ574@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100112191420.GJ574@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

On Tue, Jan 12, 2010 at 2:14 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> Hi Hal,
>
> On 14:10 Thu 31 Dec     , Hal Rosenstock wrote:
>>
>> to --details option
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> diff --git a/infiniband-diags/man/ibqueryerrors.8 b/infiniband-diags/man/ibqueryerrors.8
>> index 83a2b5a..e7feea8 100644
>> --- a/infiniband-diags/man/ibqueryerrors.8
>> +++ b/infiniband-diags/man/ibqueryerrors.8
>> @@ -1,4 +1,4 @@
>> -.TH IBQUERYERRORS 8 "Oct 30, 2009" "OpenIB" "OpenIB Diagnostics"
>> +.TH IBQUERYERRORS 8 "Dec 31, 2009" "OpenIB" "OpenIB Diagnostics"
>>
>>  .SH NAME
>>  ibqueryerrors \- query and report non-zero IB port counters
>> @@ -58,7 +58,7 @@ printed or not.  This is because data counters are only \fBprinted\fR on ports
>>  which have errors.  This means if a port has 0 errors and the \-K option is
>>  specified the data counters will be cleared without any printed output.
>>  .TP
>> -\fB\-\-details\fR include transmit discard details
>> +\fB\-\-details\fR include receive error and transmit discard details
>>  .TP
>>  \fB\-R\fR  (This option is obsolete and does nothing)
>>
>> diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
>> index 47bd2af..ceacc58 100644
>> --- a/infiniband-diags/src/ibqueryerrors.c
>> +++ b/infiniband-diags/src/ibqueryerrors.c
>> @@ -205,24 +205,31 @@ static void report_suppressed(void)
>>       printf("\n");
>>  }
>>
>> -static int print_xmitdisc_details(char *buf, size_t size, ib_portid_t * portid,
>> -                               ibnd_node_t * node, char *node_name,
>> -                               int portnum)
>> +static int print_details(char *buf, size_t size, ib_portid_t * portid,
>> +                      ibnd_node_t * node, char *node_name, int portnum,
>> +                      int j)
>>  {
>>       uint8_t pc[1024];
>>       uint32_t val = 0;
>>       int i, n;
>>
>> +     if (j != IB_PC_ERR_RCV_F && j!= IB_PC_XMT_DISCARDS_F)
>> +             return 0;
>> +
>>       memset(pc, 0, 1024);
>>
>>       if (!pma_query_via(pc, portid, portnum, ibd_timeout,
>> -                        IB_GSI_PORT_XMIT_DISCARD_DETAILS, ibmad_port)) {
>> -             IBWARN("IB_GSI_PORT_XMIT_DISCARD_DETAILS query failed on %s, "
>> -                    "%s port %d", node_name, portid2str(portid), portnum);
>> +                        (j == IB_PC_ERR_RCV_F ? IB_GSI_PORT_RCV_ERROR_DETAILS : IB_GSI_PORT_XMIT_DISCARD_DETAILS),
>> +                        ibmad_port)) {
>> +             IBWARN("%s query failed on %s, %s port %d",
>> +                     (j == IB_PC_ERR_RCV_F ? "IB_GSI_PORT_RCV_ERROR_DETAILS" : "IB_GSI_PORT_XMIT_DISCARD_DETAILS"),
>> +                     node_name, portid2str(portid), portnum);
>>               return 0;
>>       }
>>
>> -     for (n = 0, i = IB_PC_XMT_INACT_DISC_F; i <= IB_PC_XMT_SW_HOL_DISC_F;
>> +     for (n = 0,
>> +          i = (j == IB_PC_ERR_RCV_F ? IB_PC_RCV_LOCAL_PHY_ERR_F : IB_PC_XMT_INACT_DISC_F);
>> +          i <= (j == IB_PC_ERR_RCV_F ? IB_PC_RCV_LOOPING_ERR_F : IB_PC_XMT_SW_HOL_DISC_F);
>>            i++) {
>>               mad_decode_field(pc, i, (void *)&val);
>>               if (val)
>> @@ -254,10 +261,14 @@ static void print_results(ib_portid_t * portid, char *node_name,
>>                       n += snprintf(str + n, 1024 - n, " [%s == %u]",
>>                                     mad_field_name(i), val);
>>
>> +             /* If there are PortRcvErrors, get details (if supported) */
>> +             if (i == IB_PC_ERR_RCV_F && details && val) {
>> +                     n += print_details(str + n, 1024 - n, portid,
>> +                                        node, node_name, portnum, i);
>>               /* If there are PortXmitDiscards, get details (if supported) */
>> -             if (i == IB_PC_XMT_DISCARDS_F && details && val) {
>> -                     n += print_xmitdisc_details(str + n, 1024 - n, portid,
>> -                                                 node, node_name, portnum);
>> +             } else if (i == IB_PC_XMT_DISCARDS_F && details && val) {
>> +                     n += print_details(str + n, 1024 - n, portid,
>> +                                        node, node_name, portnum, i);
>>               }
>>       }
>>
>
> Could the code above be consolidated in more readable form (without
> repeating the same conditional flows)?

Yes. See a couple of minor comments below.

> Maybe like this:
>
>
> diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
> index 47bd2af..0ebe4bf 100644
> --- a/infiniband-diags/src/ibqueryerrors.c
> +++ b/infiniband-diags/src/ibqueryerrors.c
> @@ -205,30 +205,31 @@ static void report_suppressed(void)
>        printf("\n");
>  }
>
> -static int print_xmitdisc_details(char *buf, size_t size, ib_portid_t * portid,
> -                                 ibnd_node_t * node, char *node_name,
> -                                 int portnum)
> +static int query_and_dump(char *buf, size_t size, ib_portid_t * portid,
> +                        ibnd_node_t * node, char *node_name, int portnum,
> +                        const char *attr_name, uint16_t attr_id,
> +                        int start_field, int end_field)
>  {
>        uint8_t pc[1024];
>        uint32_t val = 0;
>        int i, n;
>
> -       memset(pc, 0, 1024);
> +       memset(pc, 0, sizeof(pc));
>
> -       if (!pma_query_via(pc, portid, portnum, ibd_timeout,
> -                          IB_GSI_PORT_XMIT_DISCARD_DETAILS, ibmad_port)) {
> -               IBWARN("IB_GSI_PORT_XMIT_DISCARD_DETAILS query failed on %s, "
> -                      "%s port %d", node_name, portid2str(portid), portnum);
> +       if (!pma_query_via(pc, portid, portnum, ibd_timeout, attr_id,
> +                          ibmad_port)) {
> +               IBWARN("%s query failed on %s, %s port %d", attr_name,
> +                       node_name, portid2str(portid), portnum);
>                return 0;
>        }
>
> -       for (n = 0, i = IB_PC_XMT_INACT_DISC_F; i <= IB_PC_XMT_SW_HOL_DISC_F;
> -            i++) {
> +       for (n = 0, i = start_field; i < end_field; i++) {
>                mad_decode_field(pc, i, (void *)&val);
>                if (val)
>                        n += snprintf(buf + n, size - n, " [%s == %u]",
>                                      mad_field_name(i), val);
>        }
> +
>        return n;
>  }
>
> @@ -256,8 +257,20 @@ static void print_results(ib_portid_t * portid, char *node_name,
>
>                /* If there are PortXmitDiscards, get details (if supported) */
>                if (i == IB_PC_XMT_DISCARDS_F && details && val) {
> -                       n += print_xmitdisc_details(str + n, 1024 - n, portid,
> -                                                   node, node_name, portnum);
> +                       n += query_and_dump(str + n, sizeof(buf) - n, portid,
> +                                           node, node_name, portnum,
> +                                           "PortXmitDiscardDetails",
> +                                           IB_GSI_PORT_XMIT_DISCARD_DETAILS,
> +                                           IB_PC_RCV_LOCAL_PHY_ERR_F,
> +                                           IB_PC_RCV_ERR_LAST_F);
> +               /* If there are PortRcvErrors, get details (if supported) */
> +               } else if (i == IB_PC_ERR_RCV_F && details && val) {
> +                       n += query_and_dump(str + n, sizeof(buf) - n, portid,
> +                                           node, node_name, portnum,
> +                                           "PortRecvErrorsDetails",

typo - PortRcvErrorDetails

> +                                           IB_GSI_PORT_RCV_ERROR_DETAILS,
> +                                           IB_PC_XMT_INACT_DISC_F,
> +                                           IB_PC_XMT_DISC_LAST_F);
>                }
>        }
>
> ?
>
>> @@ -364,6 +375,10 @@ static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
>>               performance_reset_via(pc, portid, port, mask, ibd_timeout,
>>                                     IB_GSI_PORT_XMIT_DISCARD_DETAILS,
>>                                     ibmad_port);
>> +             mask = 0x3F;
>> +             performance_reset_via(pc, portid, port, mask, ibd_timeout,
>> +                                   IB_GSI_PORT_RCV_ERROR_DETAILS,
>> +                                   ibmad_port);
>
> If 'mask' value is used unconditionally whouldn't it be simpler to just
> write:
>
>                performance_reset_via(pc, portid, port, 0x3f, ibd_timeout,
>                                      IB_GSI_PORT_RCV_ERROR_DETAILS,
>                                      ibmad_port);
>
> ?

Yes and that comment also applies to the instance above this for xmit
discard details reset.

-- Hal

>
> Sasha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
