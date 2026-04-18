import type { Meta, StoryObj } from '@storybook/vue3-vite'
import AppFooter from './AppFooter.vue'

const meta = {
  title: 'Components/AppFooter',
  component: AppFooter,
  tags: ['autodocs'],
  argTypes: {
    text: { control: 'text' },
  },
} satisfies Meta<typeof AppFooter>

export default meta
type Story = StoryObj<typeof meta>

export const Default: Story = {
  args: {
    text: 'Built with Tauri 2, Vue, and TypeScript',
  },
}

export const CustomText: Story = {
  args: {
    text: 'Copyright 2026 My Company. All rights reserved.',
  },
}
