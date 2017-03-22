From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC v2 for accelerated IPoIB 00/6] Enhanced mode for IPoIB driver
Date: Wed, 22 Mar 2017 13:18:30 +0200
Message-ID: <CAAk-MO_KEV9MA5Dcaz8SZagMeC4hQX456Cu8To-YRBNMeNu3pg@mail.gmail.com>
References: <1490036908-12528-1-git-send-email-erezsh@mellanox.com>
 <20170320205927.GA17225@obsidianresearch.com> <20170321114955.GB2079@mtr-leonro.local>
 <20170321161530.GB22216@obsidianresearch.com> <20170321164952.GE2079@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170321164952.GE2079-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 21, 2017 at 6:49 PM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrot=
e:
> On Tue, Mar 21, 2017 at 10:15:30AM -0600, Jason Gunthorpe wrote:
>> On Tue, Mar 21, 2017 at 01:49:55PM +0200, Leon Romanovsky wrote:
>> > On Mon, Mar 20, 2017 at 02:59:27PM -0600, Jason Gunthorpe wrote:
>> > > On Mon, Mar 20, 2017 at 09:08:22PM +0200, Erez Shitrit wrote:
>> > >
>> > > >    TODO:
>> > > >         1.change the send api in order to move it to the ndo start=
_xmit (unless it hurts the performance of the default driver)
>> > > >         2.Take out the ipoib_ah from the send signature and use ib=
_ah instead, no need with including ipoib.h
>> > > >         3.Check if/how to add rdma_netdev layer to the default ipo=
ib
>> > > >         4. splitting out the bulk rename of ipoib_priv into a sing=
le patch
>> > > >         5. change the name of the header to be ipoib_rn.h
>> > > >         6. no need to pass qkey, it is in the ah struct.
>> > >
>> > > So.. why are you resending the series? Are these going to get fixed?
>> >
>> > Sure, he will. This is why he added them to TODO so nothing will be lo=
st.
>>
>> Well.. if I assume everything done wrong in this series is fixed, then
>> it seems fine :)
>
> At least, it is written as TODO :)
>
>>
>> It looks like the only difference from what Intel started with was the
>> attach/detach_mcast which is basically how I expected this to look.
>
> Glad to hear,
>
> Erez,
> It seems that the next step is to fix TODO and to send actual patches.

Hi Jason,

As Leon wrote above, these TODO items are going to be addressed in the
actual IPoIB offload patch series. While most of the items are doable,
there are two items, which I would like to discuss more deeply.

1. The qkey is not assigned at the initialization stage and the value
in ah struct is not correct. It looks like, there is no way to avoid
forwarding qkey (the item #6 - =E2=80=9Cno need to pass qkey, it is in the =
ah
struct=E2=80=9D).

2. In order to use the send from the ndo, there is need to pass the
pointer to ib_av struct. The immediate solution is to embed it into
the skb->data (we have 20 bytes free from the pseudo header).

It can be something similar to the code below. It will work, but it
doesn=E2=80=99t look clean: (keeping pointer in the skb data..)

struct send_data
{
        struct ib_ah *av;
        u32 dqpn;
        u32 dqkey;
};

void push_send_data(struct sk_buff *skb, struct ib_ah *av, u32 dqpn,
                    u32 dqkey)
{
                struct send_data *sd;
                sd =3D (struct send_data *)skb_push(skb, sizeof(*sd));
                sd->av =3D av;
                sd->dqpn =3D dqpn;
                sd->dqkey =3D dqkey;

}

And while sending it do something like:

struct send_data *sd;
sd =3D (struct send_data *) skb->data;
skb_pull(skb, sizeof(*sd));
mah =3D to_mah(sd->av);
return mlx5i_xmit(skb, next_priv, &mah->av, sd->dqpn, sd->dqkey);


Another valuable option is just keep the send API as it is now.

Any thoughts on which implementation is better?

Thanks, Erez


>
> Thanks
>
>>
>> Jason
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
