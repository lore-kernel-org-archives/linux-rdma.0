From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] libibmad: To fix big endian problem for both 32-bit &
 64-bit SPARC
Date: Wed, 13 Mar 2013 14:58:03 +0200
Message-ID: <514077DB.9000703@mellanox.com>
References: <513F83BD.3050302@oracle.com> <5140759D.1030500@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5140759D.1030500-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 13/03/2013 14:48, Hal Rosenstock wrote:
> On 3/12/2013 3:36 PM, Boris Chiu wrote:
>> >--- a/src/dump.c
>> >+++ b/src/dump.c
>> >@@ -46,12 +46,24 @@
>> >
>> >void mad_dump_int(char *buf, int bufsz, void *val, int valsz)
>> >{
>> >+    /*
>> >+     * the val pointer passed to the dump routines are always 32 bit
>> >+     * integers for valsz <= 4 and 64 bit integer for the rest. It is
>> >never
>> >+     * uint8_t or uint16_t. This is because mad_decode_field always
>> >returns
>> >+     * the values as 32 bit integer even if they are 8 bit or 16 bit
>> >fields.
>> >+     */
>> >     switch (valsz) {
>> >     case 1:
>> >-        snprintf(buf, bufsz, "%d", *(uint32_t *) val & 0xff);
>> >+#if defined(_BIG_ENDIAN)
>> >+        val = ((uint8_t *)val) + 3;
>> >+#endif /* _BIG_ENDIAN */
> I don't understand what's different about SPARC and PPC in terms of
> this. These routines all work without this on PPC64 and PPC32.

Yep, agree, assuming the code works on other BE archs, we 1st and most 
need to understand the problem before going to solutions.

Or.



>
> At a minimum, should this be ifdef'd on something like both __sun and
> __SVR4 rather than _BIG_ENDIAN ?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
