From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] IB/srpt: Revert "Convert to percpu_ida tag allocation"
Date: Thu, 07 Apr 2016 16:56:32 -0700
Message-ID: <1460073392.18732.83.camel@haakon3.risingtidesystems.com>
References: <57055BC6.7070402@sandisk.com> <5706E548.3080002@sandisk.com>
	 <1460072224.18732.67.camel@haakon3.risingtidesystems.com>
	 <CA+55aFwOnCeKzg4SuceZm98DgN-tV7aCdtrenAS93LP7GqrZtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFwOnCeKzg4SuceZm98DgN-tV7aCdtrenAS93LP7GqrZtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2016-04-07 at 16:49 -0700, Linus Torvalds wrote:
> On Apr 7, 2016 16:37, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> >
> > Please stop trying to bypass target-pending for your target related
> > patches.
> 
> Nicholas, if you send me totally broken and untested crap, you have
> lost *all* rights to then complain about "bypass you".
> 
> So get off your high horse. Bart did the right thing, and *you* fucked
> up. Don't try to shift him be the bad guy.
> 

Yes, I fucked up and am actively fixing the regression.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
