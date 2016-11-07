From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [PATCH v4 10/10] IB/mlx5: Simplify completion into a wait_event
Date: Mon, 7 Nov 2016 11:21:11 +0530
Message-ID: <CAHv-k_-Pn=dV-8Dw1m4yS2+EVriA_-_+M4KSuvZAyP0H2YQ97g@mail.gmail.com>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
 <1477551554-30349-11-git-send-email-binoy.jayan@linaro.org> <CA+55aFxUA8r8_-yYtZfijWK_2WB+eCxMiHS-bVDN45-98V6Hdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxUA8r8_-yYtZfijWK_2WB+eCxMiHS-bVDN45-98V6Hdw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Arnd Bergmann <arnd@arndb.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

On 3 November 2016 at 21:07, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> This is wrong.

Will change it back.

> Since that "umr_context" variable is on the stack, and you are waiting
> for it to be fully done, it really should be a completion.

Thank you for sharing your insight with wait_event and completion.

-Binoy
