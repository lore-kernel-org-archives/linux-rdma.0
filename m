From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 8/9] ib_srpt: Convert srp_max_rsp_size into per port
 configfs attribute
Date: Mon, 24 Oct 2011 22:11:29 +0200
Message-ID: <CAO+b5-qXTPNQH1xdjciT+oR0GyJT_nHiP4G_6bL1UWi4rOim5w@mail.gmail.com>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
 <1319434422-15354-9-git-send-email-nab@linux-iscsi.org> <CAO+b5-p24uYKbwqCRWVik63gL-ZABgcJrqAi7ULJZEP+CK1WEg@mail.gmail.com>
 <1319485752.17450.57.camel@haakon2.linux-iscsi.org> <CAO+b5-qVEOEQ=Y_NCYJejjag=mgrGutpHLTVOKFTRsxR623tEg@mail.gmail.com>
 <1319486723.17450.59.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319486723.17450.59.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 24, 2011 at 10:05 PM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> On Mon, 2011-10-24 at 21:58 +0200, Bart Van Assche wrote:
>> On Mon, Oct 24, 2011 at 9:49 PM, Nicholas A. Bellinger
>> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
>> > On Mon, 2011-10-24 at 21:44 +0200, Bart Van Assche wrote:
>> >> On Mon, Oct 24, 2011 at 7:33 AM, Nicholas A. Bellinger
>> >> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
>> >> > +static ssize_t srpt_tpg_attrib_store_srp_max_rsp_size(
>> >> > + =A0 =A0 =A0 struct se_portal_group *se_tpg,
>> >> > + =A0 =A0 =A0 const char *page,
>> >> > + =A0 =A0 =A0 size_t count)
>> >> > +{
>> >> > + =A0 =A0 =A0 struct srpt_port *sport =3D container_of(se_tpg, =
struct srpt_port, port_tpg_1);
>> >> > + =A0 =A0 =A0 unsigned long val;
>> >> > + =A0 =A0 =A0 int ret;
>> >> > +
>> >> > + =A0 =A0 =A0 ret =3D strict_strtoul(page, 0, &val);
>> >>
>> >> If the data "page" points at only consists of digits, the above
>> >> strict_strtoul() call will trigger a past-end-of-buffer read.
>> >
>> > I don't understand what you mean here. =A0Can you provide a test c=
ase to
>> > demonstrate please..?
>>
>> echo -n "345" >$configfs_path_of_parameter.
>
> Still not sure what your getting at here..?

Only the data in page[0..count-1] is guaranteed to be initialized.
strict_strtoul() will read until it either finds whitespace or a
binary zero, so if the data in page[] does neither contain whitespace
nor a binary zero then strict_strtoul() will read past the end of the
data in page[]. There may be any data at page[count], including a
valid digit.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
