From: Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Subject: Re: interoperability issue between rxe and mlx5
Date: Thu, 15 Feb 2018 17:32:57 -0500
Message-ID: <CAN-5tyHTHyTuON_gk7E-T-ohmZ9o=ntLPsD08Sg1DTtMVe4xtw@mail.gmail.com>
References: <CAN-5tyHRcvd0Zv33putWv+gxB81a5O4EcyV8BN0GkFET+k_Gjg@mail.gmail.com>
 <CAG9sBKPtDAApLxuOvM-1pyEain-aPm-bmBu1rp7DsnuvRUT-UA@mail.gmail.com>
 <CAN-5tyHTA4851ws5sYAM5smqxvWkULfhtvBSry+pCJGVjAdTHg@mail.gmail.com>
 <CAG9sBKPXjZVofbvgA4ujtxVvNFG9+aMaXmmBd8-X+VpxaC+0LA@mail.gmail.com> <CAN-5tyGf5vj1WA5qk3K2Fs5b--r6w+gRDWfAqE-SNW7NTFTNzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN-5tyGf5vj1WA5qk3K2Fs5b--r6w+gRDWfAqE-SNW7NTFTNzg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Moni,

Is there any progress on this? Is this a softRoCE issue or mlx5 issue?

On Tue, Feb 6, 2018 at 12:08 PM, Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org> wrote:
> On Tue, Feb 6, 2018 at 10:57 AM, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> Hi Olga
>>
>>> I'm happy to test any patches. Also if you need an actual network
>>> trace if that helps, I can email that to you.
>>>
>> Thanks for suggesting that. It might help a lot.
>
> I'm attaching a few of traces.
>
>>> What I find interesting is that there is an additional request for
>>> 1021bytes at all as there 4096bytes in the response for the
>>> 4093request.
>>>
>> If I had to guess the last response was for 1024 while the requester
>> expects only 1021.
>> Therefore the requester send a read request for the remaining 1021
>> bytes (as a part of the retry mechanism) but again, gets an answer for
>> 1024 bytes.
>> This repeats until the requester gives up (max retries exceeded)
>>> Could the problem be that one side is adding padding bytes and the
>>> other side is not expecting it?
>> Padding is an option that I thought about although you said that for
>> requests under 4089 bytes the test passes (what was different)
>
> I tried again: 4088 works. 4087, 4086 doesn't .. i skipped to 4084
> which works again.
>
>>
>> thanks
>>
>> Moni
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
