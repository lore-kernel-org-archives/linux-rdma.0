From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 0/8] ib/iser: major face lift of the data path code
Date: Wed, 3 Feb 2010 17:11:36 +0100
Message-ID: <e2e108261002030811r5c740d6fr4cc055702a88aa50@mail.gmail.com>
References: <Pine.LNX.4.64.1002031721280.11944@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1002031721280.11944-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 3, 2010 at 4:30 PM, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
>
> The following patch set removes some in efficiencies in the iser data path
> through simplification and reducing the amount of code, using less atomic
> operations, avoiding TX interrupts, moving to iscsi passthrough mode,
> etc. I did my best to build it as a sequence of patches and not as one
> big re-write, to allow for better debugging (e.g bisection) and tuning.

Sounds really interesting. Do you have numbers available about how
much these patches improve throughput or decrease latency ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
