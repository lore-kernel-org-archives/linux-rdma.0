From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [infiniband-diags] [libibmad] Support new ibccquery congestion
 control tool
Date: Wed, 21 Sep 2011 10:17:38 -0400
Message-ID: <CAKzyTsxKD0r9194fd1haQ0u=1kXLDhrRXLL8q+=+inV5BM1mog@mail.gmail.com>
References: <1316469989.25283.728.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1316469989.25283.728.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On Mon, Sep 19, 2011 at 6:06 PM, Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:
> The following patches add a new tool ibccquery to infiniband-diags. =C2=
=A0It
> supports the querying of various congestion control settings. =C2=A0R=
elated
> updates to libibmad are also included.

Looks good to me :-) Just a few comments below:

Attaching rather than inlining patches makes it harder to comment.

On 0001-Add-support-for-congestion-control-mads.patch, is ib_rpc_cc_t
really needed ? Couldn't mkey in existing rpc struct just be
reused/overloaded for this (and change comment to indicate mkey or
cckey) and then some code could be eliminated ?

On 0001-Support-ibccquery-congestion-control-query-tool.patch, I'm
worried about the following:
+		/* XXX: Q3/2010 errata lists first entry offset at 80, but we assume
+		 * will be updated to 96 once CurrentTimeStamp field is word aligned=
=2E
+		 * In addition, assume max 13 log events instead of 16.  Due to
+		 * errata changes increasing size of CA log event, 16 log events is
+		 * no longer possible to fit in max MAD size.
+		 */

As far as the 13 v. 16 entries, this appears correct to me (MAD size)
but I'm concerned about changing the offset from 80 to 96 for better
alignment as this is putting the cart before the horse a little as
since these changes have not been finalized AFAIK at the IBTA.

Also, would you comment on what testing has been done with this ?

-- Hal

> Al
>
> --
> Albert Chu
> chu11-i2BcT+NCU+M@public.gmane.org
> Computer Scientist
> High Performance Systems Division
> Lawrence Livermore National Laboratory
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
