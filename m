From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 7/9] ib_srpt: Convert srp_max_rdma_size into per port
 configfs attribute
Date: Tue, 25 Oct 2011 12:32:06 +0200
Message-ID: <CAO+b5-p9xXB_sWes=uet6skkFn=xWD+vKuoOeuGwjbxYhE-ctg@mail.gmail.com>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
 <1319434422-15354-8-git-send-email-nab@linux-iscsi.org> <1319488195.17450.73.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319488195.17450.73.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 24, 2011 at 10:29 PM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
>> @@ -114,6 +114,7 @@ enum {
>> =A0 =A0 =A0 MIN_SRPT_SRQ_SIZE =3D 4,
>> =A0 =A0 =A0 DEFAULT_SRPT_SRQ_SIZE =3D 4095,
>> =A0 =A0 =A0 MAX_SRPT_SRQ_SIZE =3D 65535,
>> + =A0 =A0 MAX_SRPT_RDMA_SIZE =3D 256U,
>>
>
> Hey btw, what should the proper MAX_SRPT_RDMA_SIZE be here..?

As you can see in the ib_srpt source code, the largest value filled in
for this parameter in the IOC profile is 1U << 24.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
