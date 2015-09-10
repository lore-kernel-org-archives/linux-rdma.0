From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Thu, 10 Sep 2015 19:35:19 +0300
Message-ID: <55F1B147.405@mellanox.com>
References: <1441729478-19375-1-git-send-email-dledford@redhat.com>
 <CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
 <CA+55aFyeLEab0qjNV1+V-mX2ZhExs1z5VtdusgpDnMeNBg-d6Q@mail.gmail.com>
 <55EFA2BF.7060006@redhat.com>
 <CA+55aFwg+QCM=xaoK4ic+4AymqCYrF4Ny8WO9iY2hHFBLNT3VQ@mail.gmail.com>
 <55F02006.5020504@redhat.com>
 <CA+55aFxJovuBGpg04YM0AvrzL_TPDoHebkP21R7tO3=QMQUUXQ@mail.gmail.com>
 <CA+55aFwCwT-K_Qw3aQBXt_HbQX6v4d4EXHb3dJVCkD3kg83gzw@mail.gmail.com>
 <55F05A2F.9090005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55F05A2F.9090005-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 9/9/2015 7:11 PM, Doug Ledford wrote:
> On 09/09/2015 12:10 PM, Linus Torvalds wrote:
>> On Wed, Sep 9, 2015 at 8:44 AM, Linus Torvalds
>> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>>>
>>> Ok. I've merged it in my tree now, it's just waiting for the usual compile-test.
>>
>> Compile-test finished, and pushed out.
>>
>> Can somebody check that my conversion of roce_gid_mgmt.c actually
>> _works_ though? It compiles, but that's all I'm testing.
>
> Sure.  Thanks!
>
>

I currently don't have a bonded setup available.
I have tested the tree by setting up an active-backup bond device,
selecting each slave as an active slave and made sure the bond's GID
was applied on the correct port.
Afterwards, I've made sure that when using the bond's IP device, RoCE 
traffic was successfully sent and received (on the active port).
I think it verifies the conflicting parts of roce_gid_mgmt pretty well.

I'm adding Moni, whom I believe have such a bonded setup.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
